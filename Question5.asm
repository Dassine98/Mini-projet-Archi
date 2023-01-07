data            segment
long_tab  EQU 15
tab      db  9,4,0,0,0,4,4,0,0,0,7,9,0,9,6
compteur dw  0
data            ends



code            segment
    assume cs: code , ds: data, es: data

start:  mov ax, data
        mov ds, ax
        mov es, ax
 
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
        
        inc si
        cmp si, bx
        ja  fin
        cmp byte ptr[si],0
        je  sauter_les_0                                          ; cette boucle c est pour parcourir tous les 0 tant que c est pas la fin du tableau.
       
;****************  ICI COMMENCE LE TRAITEMENT i  *****************************************************************************************************
  
   
traitement: LODSB
        STOSB
        cmp byte ptr[si], 0
        jne traitement                                  ;remplacer le 0 par la premiere valeur non nulle trouvee dans le tableau
        je sauter_les_0                                   
                                                         
;****************       FIN DU TRAITEMENT i  *****************************************************************************************************             

avancer: inc si                                         ; c'est pour avancer aux elements suivants non encore traites.
        cmp si, bx
        jbe suivant
        jmp fin
        

fin:    mov compteur, di
        mov ax, 4c00h                                   ; exit to operating system.
        int 21h    
code            ends

                end start                               ; set entry point and stop the assembler.
