; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 19/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
; ========================
; Defini��es dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
    
; ========================
; NVIC
NVIC_EN1_R           EQU    0xE000E104
NVIC_EN2_R           EQU    0xE000E108
NVIC_PRI18_R		 EQU    0xE000E448
NVIC_PRI12_R		 EQU    0xE000E430 	
; ========================
; Defini��es dos Ports
; PORT K
GPIO_PORTK_IS_R      	EQU    0x40061404
GPIO_PORTK_IBE_R      	EQU    0x40061408
GPIO_PORTK_IEV_R      	EQU    0x4006140C
GPIO_PORTK_IM_R      	EQU    0x40061410
GPIO_PORTK_RIS_R      	EQU    0x40061414
GPIO_PORTK_ICR_R      	EQU    0x4006141C    
GPIO_PORTK_LOCK_R    	EQU    0x40061520
GPIO_PORTK_CR_R      	EQU    0x40061524
GPIO_PORTK_AMSEL_R   	EQU    0x40061528
GPIO_PORTK_PCTL_R    	EQU    0x4006152C
GPIO_PORTK_DIR_R     	EQU    0x40061400
GPIO_PORTK_AFSEL_R   	EQU    0x40061420
GPIO_PORTK_DEN_R     	EQU    0x4006151C
GPIO_PORTK_PUR_R     	EQU    0x40061510	
GPIO_PORTK_DATA_R    	EQU    0x400613FC
GPIO_PORTK              EQU    2_00001000000000

; PORT M
GPIO_PORTM_IS_R      	EQU    0x40063404
GPIO_PORTM_IBE_R      	EQU    0x40063408
GPIO_PORTM_IEV_R      	EQU    0x4006340C
GPIO_PORTM_IM_R      	EQU    0x40063410
GPIO_PORTM_RIS_R      	EQU    0x40063414
GPIO_PORTM_ICR_R      	EQU    0x4006341C    
GPIO_PORTM_LOCK_R    	EQU    0x40063520
GPIO_PORTM_CR_R      	EQU    0x40063524
GPIO_PORTM_AMSEL_R   	EQU    0x40063528
GPIO_PORTM_PCTL_R    	EQU    0x4006352C
GPIO_PORTM_DIR_R     	EQU    0x40063400
GPIO_PORTM_AFSEL_R   	EQU    0x40063420
GPIO_PORTM_DEN_R     	EQU    0x4006351C
GPIO_PORTM_PUR_R     	EQU    0x40063510	
GPIO_PORTM_DATA_R    	EQU    0x400633FC
GPIO_PORTM              EQU    2_00100000000000
; PORT N
GPIO_PORTN_LOCK_R    	EQU    0x40064520
GPIO_PORTN_CR_R      	EQU    0x40064524
GPIO_PORTN_AMSEL_R   	EQU    0x40064528
GPIO_PORTN_PCTL_R    	EQU    0x4006452C
GPIO_PORTN_DIR_R     	EQU    0x40064400
GPIO_PORTN_AFSEL_R   	EQU    0x40064420
GPIO_PORTN_DEN_R     	EQU    0x4006451C
GPIO_PORTN_PUR_R     	EQU    0x40064510	
GPIO_PORTN_DATA_R    	EQU    0x400643FC
GPIO_PORTN              EQU    2_001000000000000	
; PORT J
GPIO_PORTJ_IS_R      	EQU    0x40060404
GPIO_PORTJ_IBE_R      	EQU    0x40060408
GPIO_PORTJ_IEV_R      	EQU    0x4006040C
GPIO_PORTJ_IM_R      	EQU    0x40060410
GPIO_PORTJ_RIS_R      	EQU    0x40060414
GPIO_PORTJ_ICR_R      	EQU    0x4006041C 
GPIO_PORTJ_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_CR_R      	EQU    0x40060524
GPIO_PORTJ_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_DEN_R     	EQU    0x4006051C
GPIO_PORTJ_PUR_R     	EQU    0x40060510	
GPIO_PORTJ_DATA_R    	EQU    0x400603FC
GPIO_PORTJ              EQU    2_000000100000000

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortN_Output			; Permite chamar PortN_Output de outro arquivo
        EXPORT GPIOPortJ_Handler

		
		IMPORT EnableInterrupts
        IMPORT DisableInterrupts
		IMPORT SysTick_Wait1ms
		IMPORT sw_up
		IMPORT sw_down
									

;--------------------------------------------------------------------------------
; Fun��o GPIO_Init
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
GPIO_Init
;=====================
; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; ap�s isso verificar no PRGPIO se a porta est� pronta para uso.
; enable clock to GPIOF at clock gating register
            LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endere�o do registrador RCGCGPIO
			MOV		R1, #GPIO_PORTN                 ;Seta o bit da porta N
			ORR     R1, #GPIO_PORTJ
            STR     R1, [R0]						;Move para a mem�ria os bits das portas no endere�o do RCGCGPIO
 
            LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endere�o do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]						;L� da mem�ria o conte�do do endere�o do registrador
			MOV     R2, #GPIO_PORTN                 ;Seta os bits correspondentes �s portas para fazer a compara��o
			ORR     R2, #GPIO_PORTJ
            TST     R1, R2							;ANDS de R1 com R2
            BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o la�o. Sen�o continua executando
 
; 2. Limpar o AMSEL para desabilitar a anal�gica
            MOV     R1, #0x00					;Guarda no registrador AMSEL da porta K da mem�ria
			LDR     R0, =GPIO_PORTJ_AMSEL_R
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTN_AMSEL_R		;Carrega o R0 com o endere�o do AMSEL para a porta N
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta N da mem�ria
 
; 3. Limpar PCTL para selecionar o GPIO
            MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
            LDR     R0, =GPIO_PORTJ_PCTL_R
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTN_PCTL_R      ;Carrega o R0 com o endere�o do PCTL para a porta N
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta N da mem�ria

; 4. DIR para 0 se for entrada, 1 se for sa�da
			LDR     R0, =GPIO_PORTN_DIR_R		;Carrega o R0 com o endere�o do DIR para a porta N
			MOV     R1, #2_00000001					;PN1 & PN0 para LED
			ORR     R1, #2_00000010					;Enviar o valor 0x03 para habilitar os pinos como sa�da
            STR     R1, [R0]						;Guarda no registrador
			; O certo era verificar os outros bits da PM para n�o transformar entradas em sa�das desnecess�rias
            LDR     R0, =GPIO_PORTJ_DIR_R	   		;Carrega o R0 com o endere�o do DIR para a porta M
            MOV     R1, #0x00               		;Colocar 0 no registrador DIR para funcionar como entrada
            STR     R1, [R0]						

; 5. Limpar os bits AFSEL para 0 para selecionar GPIO 
;    Sem fun��o alternativa
            MOV     R1, #0x00						;Colocar o valor 0 para n�o setar fun��o alternativa
            LDR     R0, =GPIO_PORTJ_AFSEL_R     ;Carrega o endere�o do AFSEL da porta K
            STR     R1, [R0]                        ;Escreve na porta			
            LDR     R0, =GPIO_PORTN_AFSEL_R		;Carrega o endere�o do AFSEL da porta N
            STR     R1, [R0]                       ;Escreve na porta

; 6. Setar os bits de DEN para habilitar I/O digital
            LDR     R0, =GPIO_PORTJ_DEN_R			;Carrega o endere�o do DEN
            LDR     R1, [R0]                            ;Ler da mem�ria o registrador GPIO_PORTN_DEN_R
			MOV     R2, #2_00000011                           
            ORR     R1, R2                              
            STR     R1, [R0]                            ;Escreve no registrador da mem�ria funcionalidade digital
			
            LDR     R0, =GPIO_PORTN_DEN_R			;Carrega o endere�o do DEN
            LDR     R1, [R0]							;Ler da mem�ria o registrador GPIO_PORTN_DEN_R
			MOV     R2, #2_00000001	
			ORR     R2, #2_00000010						;Habilitar funcionalidade digital na DEN os bits 0 e 1
            ORR     R1, R2
            STR     R1, [R0]							;Escreve no registrador da mem�ria funcionalidade digital 
			
; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
			LDR     R0, =GPIO_PORTJ_PUR_R			    ;Carrega o endere�o do PUR para a porta M
			MOV     R1, #2_00000011						;Habilitar funcionalidade digital de resistor de pull-up 
            STR     R1, [R0]							;Escreve no registrador da mem�ria do resistor de pull-up

;Interrup��es
; 8. Desabilitar a interrup��o no registrador IM
			LDR     R0, =GPIO_PORTJ_IM_R			    ;Carrega o endere�o do IM para a porta M
			MOV     R1, #2_00							;Desabilitar as interrup��es  
            STR     R1, [R0]							;Escreve no registrador
            
; 9. Configurar o tipo de interrup��o por borda no registrador IS
			LDR     R0, =GPIO_PORTJ_IS_R			;Carrega o endere�o do IS para a porta M
			MOV     R1, #2_00							;Por Borda  
            STR     R1, [R0]							;Escreve no registrador

; 10. Configurar  borda �nica no registrador IBE
			LDR     R0, =GPIO_PORTJ_IBE_R				;Carrega o endere�o do IBE para a porta M
			MOV     R1, #2_00							;Borda �nica  
            STR     R1, [R0]							;Escreve no registrador

; 11. Configurar  borda de descida (bot�o pressionado) no registrador IEV
			LDR     R0, =GPIO_PORTJ_IEV_R				;Carrega o endere�o do IEV para a porta M
			MOV     R1, #2_11                			;Ambos os botoes acionam na borda de descida  
            STR     R1, [R0]							;Escreve no registrador
; 
			LDR     R0, =GPIO_PORTJ_ICR_R				
			MOV     R1, #2_11							  
            STR     R1, [R0]							
           
; 12. Habilitar a interrup��o no registrador IM
			LDR     R0, =GPIO_PORTJ_IM_R				;Carrega o endere�o do IM para a porta M
			MOV     R1, #2_11							;Habilitar as interrup��es  
            STR     R1, [R0]							;Escreve no registrador
            
;Interrup��o n�mero 72            
; 13. Setar a prioridade no NVIC
			LDR     R0, =NVIC_PRI12_R           		;Carrega o do NVIC para o grupo que tem o M entre 72 e 75
			MOV     R1, #3  		                    ;Prioridade 3
			LSL     R1, R1, #29							;Desloca 5 bits para a esquerda j� que o M � o primeiro byte do PRI18
            STR     R1, [R0]							;Escreve no registrador da mem�ria

; 14. Habilitar a interrup��o no NVIC
			LDR     R0, =NVIC_EN1_R           			;Carrega o do NVIC para o grupo que tem o M entre 64 e 95
			MOV     R1, #1
			LSL     R1, #19								;Desloca 8 bits para a esquerda j� que o M � a interrup��o do bit 8 no EN2
            STR     R1, [R0]							;Escreve no registrador da mem�ria


			BX  LR

; -------------------------------------------------------------------------------
; Fun��o PortN_Output
; Par�metro de entrada: R0 --> se os BIT1 e BIT0 est�o ligado ou desligado
; Par�metro de sa�da: N�o tem
PortN_Output
	LDR	R1, =GPIO_PORTN_DATA_R		        ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00000011                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11111100
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o par�metro de entrada
	STR R0, [R1]                            ;Escreve na porta N o barramento de dados dos pinos [N5-N0]
	BX LR									;Retorno





; -------------------------------------------------------------------------------
; Fun��o ISR GPIOPortJ_Handler (Tratamento da interrup��o)
GPIOPortJ_Handler
    LDR R0, =GPIO_PORTJ_RIS_R
    LDR R1, [R0]
    CMP R1, #2_01
    BNE CHAVE2
    LDR R0, =GPIO_PORTJ_ICR_R
    MOV R1, #2_01
    STR R1, [R0]
    PUSH {LR}
    BL sw_up  ; SW1
    POP {LR}
    B FIM_INTERRUPT

CHAVE2
    LDR R0, =GPIO_PORTJ_ICR_R
    MOV R1, #2_10
    STR R1, [R0]
    PUSH {LR}
    BL sw_down  ; SW2
    POP {LR}

FIM_INTERRUPT
    BX LR
	 
     

    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo
