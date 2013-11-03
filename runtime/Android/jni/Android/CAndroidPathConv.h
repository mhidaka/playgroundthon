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
#ifndef CAndroidPathConv_h
#define CAndroidPathConv_h

#include "AndroidFileLocation.h"

class CAndroidPathConv
{
private:
    CAndroidPathConv();
    virtual ~CAndroidPathConv();

public:
    static CAndroidPathConv& getInstance();

    const char * fullpath(const char * url, const char * suffix = 0 , bool* isReadOnly=0);

    const char * install() { build(); return m_install; }
    const char * external() { build(); return m_external; }

private:
    const char * makePath(const char * path, const char * suffix, const char * base);
    bool checkExists(const char * path);

    void build();
    void create_external();
    void create_install();

private:
    bool                m_build;
    const char      *   m_external;
    const char      *   m_install;
};

#endif
