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
//  CSockWriteStream.cpp
//
//

// #include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "CSockWriteStream.h"
#include "CSockReadStream.h"


// CSockWriteStream は、CSockReadStream が CSockReadStream::create() によって
// 生成されたタイミングで作られる、書き込み(送出)用インタフェースとなるクラス。
// socket は基本的に書き込み可能なストリームなので、必ず生成され、内部的に保持される。
CSockWriteStream::CSockWriteStream(CSockReadStream& rdStream) : m_fd(rdStream.m_fd), m_eStat(NORMAL) {}
CSockWriteStream::~CSockWriteStream() {}

bool
CSockWriteStream::sendData(unsigned char *buffer, size_t sndSize)
{
    // ひとまず、送出についてはその場で与えられたブロック全てを送出し終わるまで続ける形で実装する。
    // ゲームで使う上で問題が生じたら、それはそれで考える。
    size_t pos = 0;
    do {
        int result = write(m_fd, buffer + pos, sndSize - pos);
        if(result < 0) return false;
        pos += result;
    } while(pos < sndSize);
    return true;
}

CSockWriteStream::ESTATUS
CSockWriteStream::getStatus()
{
    return m_eStat;
}

s32
CSockWriteStream::getPosition()
{
    return 0;   // socket は位置の取得ができない
}
void
CSockWriteStream::writeU8(u8 value)
{
    m_eStat = NORMAL;
    if(!sendData(&value, 1)) {
        m_eStat = CAN_NOT_WRITE;
    }
}

void
CSockWriteStream::writeU16(u16 value)
{
    unsigned char buf[2];
    
    // big endian
    buf[0] = (value >> 8) & 0xff;
    buf[1] = value & 0xff;
    
    m_eStat = NORMAL;
    if(!sendData(buf, 2)) {
        m_eStat = CAN_NOT_WRITE;
    }    
}

void
CSockWriteStream::writeU32(u32 value)
{
    unsigned char buf[4];
    
    // big endian
    buf[0] = (value >> 24) & 0xff;
    buf[1] = (value >> 16) & 0xff;
    buf[2] = (value >> 8) & 0xff;
    buf[3] = value & 0xff;
    
    m_eStat = NORMAL;
    if(!sendData(buf, 4)) {
        m_eStat = CAN_NOT_WRITE;
    }    
    
}

void
CSockWriteStream::writeFloat(float value)
{
    m_eStat = NORMAL;
    if(!sendData((unsigned char *)&value, sizeof(float))) {
        m_eStat = CAN_NOT_WRITE;
    }    
}

void
CSockWriteStream::writeBlock(void* buffer, u32 byteSize)
{
    m_eStat = NORMAL;
    if(!sendData((unsigned char *)buffer, byteSize)) {
        m_eStat = CAN_NOT_WRITE;
    }
}
