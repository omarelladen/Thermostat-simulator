; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 19/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
    
; ========================
; NVIC
NVIC_EN1_R           EQU    0xE000E104
NVIC_EN2_R           EQU    0xE000E108
NVIC_PRI18_R		 EQU    0xE000E448
NVIC_PRI12_R		 EQU    0xE000E430 	
; ========================
; Definições dos Ports
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

; PORT A
GPIO_PORTA_IS_R      	EQU    0x40058404
GPIO_PORTA_IBE_R      	EQU    0x40058408
GPIO_PORTA_IEV_R      	EQU    0x4005840C
GPIO_PORTA_IM_R      	EQU    0x40058410
GPIO_PORTA_RIS_R      	EQU    0x40058414
GPIO_PORTA_ICR_R      	EQU    0x4005841C 
GPIO_PORTA_LOCK_R    	EQU    0x40058520
GPIO_PORTA_CR_R      	EQU    0x40058524
GPIO_PORTA_AMSEL_R   	EQU    0x40058528
GPIO_PORTA_PCTL_R    	EQU    0x4005852C
GPIO_PORTA_DIR_R     	EQU    0x40058400
GPIO_PORTA_AFSEL_R   	EQU    0x40058420
GPIO_PORTA_DEN_R     	EQU    0x4005851C
GPIO_PORTA_PUR_R     	EQU    0x40058510	
GPIO_PORTA_DATA_R    	EQU    0x400583FC
GPIO_PORTA              EQU    2_000000000000001

; PORT Q
GPIO_PORTQ_IS_R      	EQU    0x40066404
GPIO_PORTQ_IBE_R      	EQU    0x40066408
GPIO_PORTQ_IEV_R      	EQU    0x4006640C
GPIO_PORTQ_IM_R      	EQU    0x40066410
GPIO_PORTQ_RIS_R      	EQU    0x40066414
GPIO_PORTQ_ICR_R      	EQU    0x4006641C 
GPIO_PORTQ_LOCK_R    	EQU    0x40066520
GPIO_PORTQ_CR_R      	EQU    0x40066524
GPIO_PORTQ_AMSEL_R   	EQU    0x40066528
GPIO_PORTQ_PCTL_R    	EQU    0x4006652C
GPIO_PORTQ_DIR_R     	EQU    0x40066400
GPIO_PORTQ_AFSEL_R   	EQU    0x40066420
GPIO_PORTQ_DEN_R     	EQU    0x4006651C
GPIO_PORTQ_PUR_R     	EQU    0x40066510	
GPIO_PORTQ_DATA_R    	EQU    0x400663FC
GPIO_PORTQ              EQU    2_100000000000000
	
; PORT P
GPIO_PORTP_IS_R      	EQU    0x40065404
GPIO_PORTP_IBE_R      	EQU    0x40065408
GPIO_PORTP_IEV_R      	EQU    0x4006540C
GPIO_PORTP_IM_R      	EQU    0x40065410
GPIO_PORTP_RIS_R      	EQU    0x40065414
GPIO_PORTP_ICR_R      	EQU    0x4006541C 
GPIO_PORTP_LOCK_R    	EQU    0x40065520
GPIO_PORTP_CR_R      	EQU    0x40065524
GPIO_PORTP_AMSEL_R   	EQU    0x40065528
GPIO_PORTP_PCTL_R    	EQU    0x4006552C
GPIO_PORTP_DIR_R     	EQU    0x40065400
GPIO_PORTP_AFSEL_R   	EQU    0x40065420
GPIO_PORTP_DEN_R     	EQU    0x4006551C
GPIO_PORTP_PUR_R     	EQU    0x40065510	
GPIO_PORTP_DATA_R    	EQU    0x400653FC
GPIO_PORTP              EQU    2_010000000000000
	
; PORT B
GPIO_PORTB_IS_R      	EQU    0x40059404
GPIO_PORTB_IBE_R      	EQU    0x40059408
GPIO_PORTB_IEV_R      	EQU    0x4005940C
GPIO_PORTB_IM_R      	EQU    0x40059410
GPIO_PORTB_RIS_R      	EQU    0x40059414
GPIO_PORTB_ICR_R      	EQU    0x4005941C 
GPIO_PORTB_LOCK_R    	EQU    0x40059520
GPIO_PORTB_CR_R      	EQU    0x40059524
GPIO_PORTB_AMSEL_R   	EQU    0x40059528
GPIO_PORTB_PCTL_R    	EQU    0x4005952C
GPIO_PORTB_DIR_R     	EQU    0x40059400
GPIO_PORTB_AFSEL_R   	EQU    0x40059420
GPIO_PORTB_DEN_R     	EQU    0x4005951C
GPIO_PORTB_PUR_R     	EQU    0x40059510	
GPIO_PORTB_DATA_R    	EQU    0x400593FC
GPIO_PORTB              EQU    2_000000000000010

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortN_Output			; Permite chamar PortN_Output de outro arquivo
        EXPORT GPIOPortJ_Handler

		EXPORT GPIO_PORTP_DATA_R
		EXPORT GPIO_PORTQ_DATA_R
		EXPORT GPIO_PORTA_DATA_R
		EXPORT GPIO_PORTB_DATA_R
			
		EXPORT PortP_Output
		EXPORT PortQ_Output
		EXPORT PortA_Output
		EXPORT PortB_Output
			

		IMPORT EnableInterrupts
        IMPORT DisableInterrupts
		IMPORT SysTick_Wait1ms
		IMPORT sw_up
		IMPORT sw_down
									

;--------------------------------------------------------------------------------
; Função GPIO_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_Init
;=====================
; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; após isso verificar no PRGPIO se a porta está pronta para uso.
; enable clock to GPIOF at clock gating register
            LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endereço do registrador RCGCGPIO
			MOV		R1, #GPIO_PORTN                 ;Seta o bit da porta N
			ORR     R1, #GPIO_PORTJ
			ORR     R1, #GPIO_PORTP
			ORR     R1, #GPIO_PORTQ
			ORR     R1, #GPIO_PORTA
			ORR     R1, #GPIO_PORTB
            STR     R1, [R0]						;Move para a memória os bits das portas no endereço do RCGCGPIO
 
            LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endereço do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]						;Lê da memória o conteúdo do endereço do registrador
			MOV     R2, #GPIO_PORTN                 ;Seta os bits correspondentes às portas para fazer a comparação
			ORR     R2, #GPIO_PORTJ
			ORR     R2, #GPIO_PORTP
			ORR     R2, #GPIO_PORTQ
			ORR     R2, #GPIO_PORTA
			ORR     R2, #GPIO_PORTB
            TST     R1, R2							;ANDS de R1 com R2
            BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o laço. Senão continua executando
 
; 2. Limpar o AMSEL para desabilitar a analógica
            MOV     R1, #0x00					;Guarda no registrador AMSEL da porta K da memória
			LDR     R0, =GPIO_PORTJ_AMSEL_R
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTN_AMSEL_R		;Carrega o R0 com o endereço do AMSEL para a porta N
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta N da memória
 			LDR     R0, =GPIO_PORTP_AMSEL_R
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTQ_AMSEL_R
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTA_AMSEL_R
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTB_AMSEL_R
			STR     R1, [R0]
			
; 3. Limpar PCTL para selecionar o GPIO
            MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
            LDR     R0, =GPIO_PORTJ_PCTL_R
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTN_PCTL_R      ;Carrega o R0 com o endereço do PCTL para a porta N
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta N da memória
            LDR     R0, =GPIO_PORTP_PCTL_R
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTQ_PCTL_R
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTA_PCTL_R
			STR     R1, [R0]
			LDR     R0, =GPIO_PORTB_PCTL_R
			STR     R1, [R0]
			
; 4. DIR para 0 se for entrada, 1 se for saída
			LDR     R0, =GPIO_PORTN_DIR_R		;Carrega o R0 com o endereço do DIR para a porta N
			MOV     R1, #2_00000001					;PN1 & PN0 para LED
			ORR     R1, #2_00000010					;Enviar o valor 0x03 para habilitar os pinos como saída
            STR     R1, [R0]						;Guarda no registrador
			; O certo era verificar os outros bits da PM para não transformar entradas em saídas desnecessárias
            LDR     R0, =GPIO_PORTJ_DIR_R	   		;Carrega o R0 com o endereço do DIR para a porta M
            MOV     R1, #0x00               		;Colocar 0 no registrador DIR para funcionar como entrada
            STR     R1, [R0]

			LDR     R0, =GPIO_PORTP_DIR_R		
			MOV     R1, #2_00100000					
            STR     R1, [R0]
			
			LDR     R0, =GPIO_PORTQ_DIR_R		
			MOV     R1, #2_00001111					
            STR     R1, [R0]

			LDR     R0, =GPIO_PORTA_DIR_R		
			MOV     R1, #2_11110000					
            STR     R1, [R0]
			
			LDR     R0, =GPIO_PORTB_DIR_R		
			MOV     R1, #2_00110000					
            STR     R1, [R0]

; 5. Limpar os bits AFSEL para 0 para selecionar GPIO 
;    Sem função alternativa
            MOV     R1, #0x00						;Colocar o valor 0 para não setar função alternativa
            LDR     R0, =GPIO_PORTJ_AFSEL_R     ;Carrega o endereço do AFSEL da porta K
            STR     R1, [R0]                        ;Escreve na porta			
            LDR     R0, =GPIO_PORTN_AFSEL_R		;Carrega o endereço do AFSEL da porta N
            STR     R1, [R0]                       ;Escreve na porta
			LDR     R0, =GPIO_PORTP_AFSEL_R		
            STR     R1, [R0]
			LDR     R0, =GPIO_PORTQ_AFSEL_R		
            STR     R1, [R0] 
			LDR     R0, =GPIO_PORTA_AFSEL_R		
            STR     R1, [R0] 
			LDR     R0, =GPIO_PORTB_AFSEL_R		
            STR     R1, [R0]
			
; 6. Setar os bits de DEN para habilitar I/O digital
            LDR     R0, =GPIO_PORTJ_DEN_R			;Carrega o endereço do DEN
            LDR     R1, [R0]                            ;Ler da memória o registrador GPIO_PORTN_DEN_R
			MOV     R2, #2_00000011                           
            ORR     R1, R2                              
            STR     R1, [R0]                            ;Escreve no registrador da memória funcionalidade digital
			
            LDR     R0, =GPIO_PORTN_DEN_R			;Carrega o endereço do DEN
            LDR     R1, [R0]							;Ler da memória o registrador GPIO_PORTN_DEN_R
			MOV     R2, #2_00000001	
			ORR     R2, #2_00000010						;Habilitar funcionalidade digital na DEN os bits 0 e 1
            ORR     R1, R2
            STR     R1, [R0]							;Escreve no registrador da memória funcionalidade digital 
			
			LDR     R0, =GPIO_PORTP_DEN_R			
            LDR     R1, [R0]                        
			MOV     R2, #2_00100000                           
            ORR     R1, R2                              
            STR     R1, [R0] 

			LDR     R0, =GPIO_PORTQ_DEN_R			
            LDR     R1, [R0]                        
			MOV     R2, #2_00001111                           
            ORR     R1, R2                              
            STR     R1, [R0]
			
			LDR     R0, =GPIO_PORTA_DEN_R			
            LDR     R1, [R0]                        
			MOV     R2, #2_11110000                           
            ORR     R1, R2                              
            STR     R1, [R0]
			
			LDR     R0, =GPIO_PORTB_DEN_R			
            LDR     R1, [R0]                        
			MOV     R2, #2_00110000                           
            ORR     R1, R2                              
            STR     R1, [R0]
			
; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
			LDR     R0, =GPIO_PORTJ_PUR_R			    ;Carrega o endereço do PUR para a porta M
			MOV     R1, #2_00000011						;Habilitar funcionalidade digital de resistor de pull-up 
            STR     R1, [R0]							;Escreve no registrador da memória do resistor de pull-up

;Interrupções
; 8. Desabilitar a interrupção no registrador IM
			LDR     R0, =GPIO_PORTJ_IM_R			    ;Carrega o endereço do IM para a porta M
			MOV     R1, #2_00							;Desabilitar as interrupções  
            STR     R1, [R0]							;Escreve no registrador
            
; 9. Configurar o tipo de interrupção por borda no registrador IS
			LDR     R0, =GPIO_PORTJ_IS_R			;Carrega o endereço do IS para a porta M
			MOV     R1, #2_00							;Por Borda  
            STR     R1, [R0]							;Escreve no registrador

; 10. Configurar  borda única no registrador IBE
			LDR     R0, =GPIO_PORTJ_IBE_R				;Carrega o endereço do IBE para a porta M
			MOV     R1, #2_00							;Borda Única  
            STR     R1, [R0]							;Escreve no registrador

; 11. Configurar  borda de descida (botão pressionado) no registrador IEV
			LDR     R0, =GPIO_PORTJ_IEV_R				;Carrega o endereço do IEV para a porta M
			MOV     R1, #2_11                			;Ambos os botoes acionam na borda de descida  
            STR     R1, [R0]							;Escreve no registrador
; 
			LDR     R0, =GPIO_PORTJ_ICR_R				
			MOV     R1, #2_11							  
            STR     R1, [R0]							
           
; 12. Habilitar a interrupção no registrador IM
			LDR     R0, =GPIO_PORTJ_IM_R				;Carrega o endereço do IM para a porta M
			MOV     R1, #2_11							;Habilitar as interrupções  
            STR     R1, [R0]							;Escreve no registrador
            
;Interrupção número 72            
; 13. Setar a prioridade no NVIC
			LDR     R0, =NVIC_PRI12_R           		;Carrega o do NVIC para o grupo que tem o M entre 72 e 75
			MOV     R1, #3  		                    ;Prioridade 3
			LSL     R1, R1, #29							;Desloca 5 bits para a esquerda já que o M é o primeiro byte do PRI18
            STR     R1, [R0]							;Escreve no registrador da memória

; 14. Habilitar a interrupção no NVIC
			LDR     R0, =NVIC_EN1_R           			;Carrega o do NVIC para o grupo que tem o M entre 64 e 95
			MOV     R1, #1
			LSL     R1, #19								;Desloca 8 bits para a esquerda já que o M é a interrupção do bit 8 no EN2
            STR     R1, [R0]							;Escreve no registrador da memória


			BX  LR


; -------------------------------------------------------------------------------
; Função PortN_Output
; Parâmetro de entrada: R0 --> se os BIT1 e BIT0 estão ligado ou desligado
; Parâmetro de saída: Não tem
PortN_Output
	LDR	R1, =GPIO_PORTN_DATA_R		        ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00000011                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11111100
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta N o barramento de dados dos pinos [N5-N0]
	
	BX LR									;Retorno

PortP_Output
	LDR	R1, =GPIO_PORTP_DATA_R		        ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00100000                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11111100
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta N o barramento de dados dos pinos [N5-N0]
	
	BX LR									;Retorno

PortQ_Output
	LDR	R1, =GPIO_PORTQ_DATA_R		        ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00001111                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11111100
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta N o barramento de dados dos pinos [N5-N0]
	
	BX LR									;Retorno

PortA_Output
	LDR	R1, =GPIO_PORTA_DATA_R		        ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_11110000                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11111100
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta N o barramento de dados dos pinos [N5-N0]
	
	BX LR									;Retorno

PortB_Output
	LDR	R1, =GPIO_PORTB_DATA_R		        ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00110000                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11111100
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta N o barramento de dados dos pinos [N5-N0]
	
	BX LR									;Retorno


; -------------------------------------------------------------------------------
; Função ISR GPIOPortJ_Handler (Tratamento da interrupção)
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
	 
     

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo
