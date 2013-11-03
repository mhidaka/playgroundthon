/* 
   Copyright 2013 KLab Inc.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
//
//  CSockReadStream.cpp
//
//
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
// #include <iostream>

#include "CPFInterface.h"
#include "CSockReadStream.h"
#include "CSockWriteStream.h"

CSockReadStream::CSockReadStream() : m_writeStream(0), m_eStat(NORMAL), m_fd(0), m_lastPos(0), m_getPos(0) {}
CSockReadStream::~CSockReadStream()
{
    // 生成時に作成した書き込み用ストリームオブジェクトを破棄
    if(m_writeStream) delete m_writeStream;
    // 破棄時にソケットをクローズする
    if(m_fd) close(m_fd);    
}

/*!
 ¥param  hostname   IPアドレス表記またはFQDN表記のホスト指定
 ¥param  port       接続する TCP/IP の port 番号

 ¥return 接続成功ならば true, 失敗すれば false
 */
int
CSockReadStream::sock_connect(const char *hostname, int port)
{
    int dstSocket;
    struct sockaddr_in dstAddr;

    m_fd = 0;
    memset(&dstAddr, 0, sizeof(dstAddr));
    dstAddr.sin_port = htons(port);
    dstAddr.sin_family = AF_INET;
    dstAddr.sin_addr.s_addr = inet_addr(hostname);

    if(dstAddr.sin_addr.s_addr == 0xffffffff) {
        struct hostent *host;
        host = gethostbyname(hostname);
        if(!host) {
        	DEBUG_PRINT("CSockReadStream::gethostbyname() failed.");
        	return -1;
        }
        dstAddr.sin_addr.s_addr = *(unsigned int *)host->h_addr_list[0];
    }
    dstSocket = socket(AF_INET, SOCK_STREAM, 0);

    if(dstSocket < 0) {
    	DEBUG_PRINT("bad socket.(%d) errno=%d", dstSocket, errno);
    	return -1;
    }

    if(0 > connect(dstSocket, (struct sockaddr *)&dstAddr, sizeof(dstAddr))) {
    	DEBUG_PRINT("could not connect()");
    	close(dstSocket);
    	return -1;
    }

    // 取得したディスクリプタは、ノンブロックモードにて運用する。
    int flags = fcntl(dstSocket, F_GETFL, 0);
    fcntl(dstSocket, F_SETFL, flags | O_NONBLOCK);

    return dstSocket;
}

bool
CSockReadStream::setStatus()
{
    switch(errno)
    {
        default:
        	m_eStat = CLOSED;
        	if(m_fd > 0) {
        		close(m_fd);
        		m_fd = 0;
        	}
            break;
        case EAGAIN:
            m_eStat = NOT_AVAILABLE;
            break;
        case ETIMEDOUT:
            m_eStat = CLOSED;
            if(m_fd > 0) {
                close(m_fd);
                m_fd = 0;
            }
            DEBUG_PRINT("errno = ETIMEDOUT");
            break;
    }
    return false;   // 必ず false を返す
}
/*!
 ¥return  リングバッファ読み込みが正常終了していれば true, 失敗ならば false
 
 受信データをリングバッファに蓄積します。
 */
bool
CSockReadStream::readRingBuf()
{
    if((m_lastPos > m_getPos) && (m_lastPos < READ_BUFSIZ)) {
        int result = read(m_fd, m_readBuf + m_lastPos, READ_BUFSIZ - m_lastPos);
        if(result < 0) return false;
        m_lastPos += result;
    }
    if((m_lastPos == READ_BUFSIZ) && (m_getPos > 0)) {
        int result = read(m_fd, m_readBuf, m_getPos);
        if(result < 0) return false;
        if(result > 0) m_lastPos = result;
    } else if(m_lastPos < m_getPos) {
        int result = read(m_fd, m_readBuf + m_lastPos, m_getPos - m_lastPos);
        if(result < 0) return false;
        m_lastPos += result;
    } else if(m_getPos == 0 && m_lastPos == 0) {
        // バッファが完全に空の状態
        int result = read(m_fd, m_readBuf, READ_BUFSIZ);
        if(result < 0) return false;
        m_lastPos += result;
    }
    return true;
}


/*!
 ¥param buf     データを受け取るバッファ
 ¥param size    要求サイズ

 読み込みバッファを経由して、指定サイズのデータを取得する。
 ネットワークの読み込みが追いつかない場合、読み込みポインタが更新されない。
 */
bool
CSockReadStream::requestData(unsigned char * buf, size_t reqSize)
{
    // 最初にステータスを NORMAL にする。途中で問題があれば書きかわる。
    // 正常系を通れば問題なくNORMALを維持できる。
    m_eStat = NORMAL;

    // リングバッファへの読み込みを試みる。
    if(!readRingBuf())
    {
        setStatus();
    }

    // リングバッファの残りサイズが要求サイズ以上であるか確認し、サイズが足りなければ false を返す。
    size_t leftSize = left_size();
    if( !reqSize || leftSize < reqSize)
    {
        // m_eStat = NOT_AVAILABLE;
        return false;
    }
    // リングバッファから指定のバッファに指定サイズを転送する
    int rdsiz = ((READ_BUFSIZ - m_getPos) >= reqSize) ? reqSize : (READ_BUFSIZ - m_getPos);
    memcpy(buf, m_readBuf + m_getPos, rdsiz);
    m_getPos += rdsiz;
    if(m_getPos == READ_BUFSIZ) {
    	m_getPos = 0;
    	if(m_lastPos==READ_BUFSIZ) m_lastPos = 0;
    }
    
    if(0 < (reqSize - rdsiz)) {
        memcpy(buf + rdsiz, m_readBuf, reqSize - rdsiz);
        m_getPos += reqSize - rdsiz;
    }

    // 読み込み済みデータに追いついたら、一旦バッファを仕切り直す。
    if(m_lastPos == m_getPos) m_lastPos = m_getPos = 0;
    
    return true;
}

CSockReadStream *
CSockReadStream::openStream(const char * sockName)
{
    CSockReadStream * pStream = 0;

    pStream = new CSockReadStream();

    // 渡されたホスト:portを分解する
    char * strHost = 0;
    char * strPort = 0;

    for(int i = 0; sockName[i]; i++) {
    	if(sockName[i] == ':') {
    		strHost = new char [ i + 1 ];
    		strncpy(strHost, sockName, i);
    		strHost[i] = 0;
    		int plen = strlen(sockName + i + 1);
    		strPort = new char [ plen + 1 ];
            strcpy(strPort, sockName + i + 1);
            break;
    	}
    }
    if(!strHost || !strPort) {
    	// 与えられた名称の書式が不正
    	pStream->m_eStat = NOT_FOUND;
    	DEBUG_PRINT("CSockReadStream::bad url.");
    	if( strPort )
    	{
    		delete [] strPort;
    		strPort = NULL;
    	}
    	if( strHost )
    	{
    		delete [] strHost;
    		strHost = NULL;
    	}
    	return pStream;
    }


    // port を数値に変換する。
    // 数列であることを確認。
    for(int i = 0; strPort[i]; i++) {
    	if(strPort[i] < '0' || strPort[i] > '9') {
	 	    // 数字以外が含まれている場合は接続先指定として不正
    		pStream->m_eStat = NOT_FOUND;
        	DEBUG_PRINT("CSockReadStream::bad port.");
            if( strPort )
            {
                delete [] strPort;
                strPort = NULL;
            }
            if( strHost )
            {
                delete [] strHost;
                strHost = NULL;
            }
		    return pStream;
	    }
    }

    // 特に問題ないので、port を数値に変換する
    int port = atoi(strPort);

    // 接続を試みる
    int fd = pStream->sock_connect(strHost, port);

    if(fd < 0) {
    	// 接続に失敗した場合
        pStream->m_eStat = NOT_FOUND;
        DEBUG_PRINT("CSockReadStream::connection failed.:[%s][%d]", strHost, port);
    	if( strPort )
    	{
    		delete [] strPort;
    		strPort = NULL;
    	}
    	if( strHost )
    	{
    		delete [] strHost;
    		strHost = NULL;
    	}
        return pStream;
    }
    pStream->m_fd = fd;
    // 同時に書き込み用クラスを生成
    pStream->m_writeStream = new CSockWriteStream(*pStream);

    pStream->m_eStat = NORMAL;
    
    if( strPort )
    {
    	delete [] strPort;
    	strPort = NULL;
    }
    if( strHost )
    {
    	delete [] strHost;
    	strHost = NULL;
    }
    return pStream;
}


s32  
CSockReadStream::getSize()
{
	m_eStat = NORMAL;
	if(!readRingBuf()) {
		setStatus();
	}
	size_t leftSize = left_size();
	return (s32)leftSize;
}
s32
CSockReadStream::getPosition()
{
    // ネットワークソケットは位置を取得できない
    return 0;
}

/*
 ネットワークストリームの場合、全ての読み込みメソッドにおいて
 *必ずしも読み込みが成功するわけではない* ことに注意する必要がある。
 相手ホストがデータを送信していない場合、たとえ8bitのデータでも読み込みに失敗することがある。
 
 readBlock() 以外は読み込みの成否を返すようには出来ていないため、
 実行後に必ず getStatus() でステータスを確認し、NOT_AVAILABLE である場合は
 戻り値に意味が無いものとして破棄する必要がある。
*/

u8
CSockReadStream::readU8()
{
    u8 buf;
    if(!requestData(&buf, 1))return 0xff;
    return buf;
}


u16
CSockReadStream::readU16()
{
    u8 buf[2];
    if(!requestData(buf, 2))return 0xffff;
    return (u16)buf[0] << 8 | (u16)buf[1];
}

u32
CSockReadStream::readU32()
{
    u8 buf[4];
    if(!requestData(buf, 4)) return 0xffff;
    return ((u32)buf[0] << 24) | ((u32)buf[1] << 16) | ((u32)buf[2] << 8) | (u32)buf[3];
    
}
float
CSockReadStream::readFloat()
{
    float buf;
    if(!requestData((unsigned char *)&buf, sizeof(float))) return -6e24;
    return buf;
}

/*!
 指定サイズ読み込み失敗時に読み込み位置を更新しないリングバッファ方式のため、
 byteSize にはリングバッファのサイズ以上を指定できない。
 */
bool
CSockReadStream::readBlock(void * buffer, u32 byteSize)
{
    if(!requestData((unsigned char *)buffer, byteSize)) return false;
    return true;
}

CSockReadStream::ESTATUS
CSockReadStream::getStatus()
{
    return m_eStat;
}

// この Stream から書き込み(送出)可能なストリームを生成する
IWriteStream *
CSockReadStream::getWriteStream()
{
    return m_writeStream;
}


int
CSockReadStream::readU16arr(u16 *pBufferU16, int items)
{
    // リングバッファに指定サイズを要求するので、全て取得できるか、全く取れないかのどちらかになる。
    if(!requestData((unsigned char *)pBufferU16, items * sizeof(u16))) return 0;

    // iOS および Android/ARM では元から big endian なのでバイトオーダー入れ替えは発生しない。

    return items;
}

int
CSockReadStream::readU32arr(u32 *pBufferU32, int items)
{
    // リングバッファに指定サイズを要求するので、全て取得できるか、全く取れないかのどちらかになる。
    if(!requestData((unsigned char *)pBufferU32, items * sizeof(u32))) return 0;

    // iOS および Android/ARM では元から big endian なのでバイトオーダー入れ替えは発生しない。

    return items;
}
