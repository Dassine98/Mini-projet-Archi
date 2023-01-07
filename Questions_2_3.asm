data            segment
long_tab  EQU 15
tab      db  9,4,0,0,0,4,4,0,0,0,7,9,0,9,6
taille   dw  ?                                           ; le nbr d element a transferer
nb       dw  0 
                                          ; contient le nombre de "0" dans le tableau pour chaque prochain traitement.   
compteur dw  0

data            ends



code            segment
    assume cs: code , ds: data, es:d data

start:  mov ax, data
        mov ds, ax
        mov es, ax
                                                        ;pour mettre le df a 0 
        cld 
        mov si, offset tab                              ; si est utilise pour parcourir les elements du tableau
        mov bx, si
        add bx, long_tab                                ; nombre d elements du tableau
        dec bx                                          ; contient position du dernier element du tableau (fin du tableau)
                    
suivant: cmp byte ptr[si], 0
        jne avancer                                     ; tant que ce n'est pas 0 on avance
    
;premier 0 qui est rencontre de chaque nouvelle sequence de 0 
       
        mov di, si                                      ; DI pour fixer l indice du premier 0 de la sequence servant comme debut de la zone destination de transfert

sauter_les_0:  
        inc nb ; nbre de 0
        inc si
        cmp si, bx
        ja  etiq
        cmp byte ptr[si],0
        je  sauter_les_0                                ; cette boucle c est pour parcourir tous les 0 tant que c est pas la fin du tableau.
       
;****************  ICI COMMENCE LE TRAITEMENT i  *****************************************************************************************************
        
        mov taille, bx  
        sub taille, si
        inc taille 
        mov cx, taille                                  ; taille contient le nombre d'elements a decaler vers la gauche vers position DI

   
traitement: LODSB                                       ;OU MOVSB  
        STOSB                                            
        loop traitement                                 ; chaque iteration de cette boucle execute le transfert d'une seule case de la position si vers celle de di  
                          

        sub si, taille
        sub si, nb                                      ; redeplacer si a l'element suivant non traite du tableau
        mov di, 0
          
        sub bx, nb                                      ; reduire la valeur de bx
        mov nb, 0                                       ; reinitialiser le nombre de zero  pour le prochain traitement.
        jmp suivant                                     ; passer au test du reste des elements du tableau

;****************       FIN DU TRAITEMENT i  *****************************************************************************************************             

avancer: inc si                                         ; c'est pour avancer aux elements suivants non encore traites.
        cmp si, bx
        jbe suivant
        jmp fin
           
etiq:   sub bx, nb                                      ; reduire la valeur de bx

fin:    
        mov compteur,si
        mov ax, 4c00h                                   ; exit to operating system.
        int 21h    
code            ends

                end start                               ; set entry point and stop the assembler.
