; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 15/03/2018
; Este programa espera o usuário apertar a chave USR_SW1 e/ou a chave USR_SW2.
; Caso o usuário pressione a chave USR_SW1, acenderá o LED2. Caso o usuário pressione 
; a chave USR_SW2, acenderá o LED1. Caso as duas chaves sejam pressionadas, os dois 
; LEDs acendem.

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------

; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM		

TEMP_MAX_TARGET EQU 50 
TEMP_MIN_TARGET EQU 5
; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>
		EXPORT sw_up
		EXPORT sw_down
		IMPORT PLL_Init
		IMPORT SysTick_Init
		IMPORT SysTick_Wait1ms										
		IMPORT GPIO_Init
        IMPORT PortN_Output
			
		IMPORT GPIO_PORTP_DATA_R
		IMPORT GPIO_PORTQ_DATA_R
		IMPORT GPIO_PORTA_DATA_R
		IMPORT GPIO_PORTB_DATA_R
		
					
		IMPORT PortP_Output
		IMPORT PortQ_Output
		IMPORT PortA_Output
		IMPORT PortB_Output

; -------------------------------------------------------------------------------
; Função main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO


	MOV R12, #15  ; temp_now
	MOV R11, #25  ; setpoint
	
	MOV R3, #0  ; contador
	
MainLoop
;	Colocar a informação da dezena em PA7:PA4 e PQ3:PQ0  ; UDIV por 10 
	PUSH {LR}
	BL dezena_to_bcd			 
	POP {LR}

;	Ativar o transistor Q2 (PB4)
	MOV R0, #2_00010000
	PUSH {LR}
	BL PortB_Output
	POP {LR}
	
;	Esperar 1ms
	MOV R0, #1			 
	PUSH {LR}
	BL SysTick_Wait1ms			 
	POP {LR}
	
;	Desativar o transistor Q2 (PB4)
	MOV R0, #2_00000000
	PUSH {LR}
	BL PortB_Output
	POP {LR}
	
;	Esperar 1ms
	MOV R0, #1				 
	PUSH {LR}
	BL SysTick_Wait1ms			 
	POP {LR}


;	Colocar a informação da unidade em PA7:PA4 e PQ3:PQ0  ; MLS
	PUSH {LR}
	BL unidade_to_bcd			 
	POP {LR}

;	Ativar o transistor Q3 (PB5)
	MOV R0, #2_00100000
	PUSH {LR}
	BL PortB_Output
	POP {LR}
	
;	Esperar 1ms
	MOV R0, #1			 
	PUSH {LR}
	BL SysTick_Wait1ms			 
	POP {LR}
	
;	Desativar o transistor Q3 (PB5)
	MOV R0, #2_00000000
	PUSH {LR}
	BL PortB_Output
	POP {LR}
	
;	Esperar 1ms
	MOV R0, #1			 
	PUSH {LR}
	BL SysTick_Wait1ms			 
	POP {LR}


;	Colocar a informação dos LEDs em PA7:PA4 e PQ3:PQ0;
	MOV R0, R11
	PUSH {LR}
	BL PortA_Output
	POP {LR}
	
	MOV R0, R11
	PUSH {LR}
	BL PortQ_Output
	POP {LR}
	
;	Ativar o transistor Q1 (PP5)
	MOV R0, #2_00100000
	PUSH {LR}
	BL PortP_Output
	POP {LR}
	
;	Esperar 1ms
	MOV R0, #1			 
	PUSH {LR}
	BL SysTick_Wait1ms			 
	POP {LR}
	

	;	Desativar o transistor Q1 (PP5)
	MOV R0, #2_00000000
	PUSH {LR}
	BL PortP_Output
	POP {LR}
	
;	Esperar 1ms
	MOV R0, #1			 
	PUSH {LR}
	BL SysTick_Wait1ms			 
	POP {LR}


;	decrementar contador
;	se passou 1s, aumentar ou diminuir temperatural atual
;	reiniciar contador

	ADD R3, #6
	CMP R3, #1000
	 
	PUSH {LR}
	BLGE passou_1s
	POP {LR}
	


	B MainLoop

dezena_to_bcd
	MOV R0, #10
	UDIV R8, R12, R0
	
	PUSH {LR}
	BL bin_to_bcd
	POP {LR}
	
	BX LR

unidade_to_bcd
	MOV R0, #10
	UDIV R9, R12, R0
	MLS R8, R9, R0, R12
	
	PUSH {LR}
	BL bin_to_bcd
	POP {LR}
	
	BX LR

bin_to_bcd
	CMP R8, #0
	PUSH {LR}
	BLEQ bcd_0
	POP {LR}
	
	CMP R8, #1
	PUSH {LR}
	BLEQ bcd_1
	POP {LR}
	
	CMP R8, #2
	PUSH {LR}
	BLEQ bcd_2
	POP {LR}
	
	CMP R8, #3
	PUSH {LR}
	BLEQ bcd_3
	POP {LR}
	
	CMP R8, #4
	PUSH {LR}
	BLEQ bcd_4
	POP {LR}
	
	CMP R8, #5
	PUSH {LR}
	BLEQ bcd_5
	POP {LR}
	
	CMP R8, #6
	PUSH {LR}
	BLEQ bcd_6
	POP {LR}
	
	CMP R8, #7
	PUSH {LR}
	BLEQ bcd_7
	POP {LR}
	
	CMP R8, #8
	PUSH {LR}
	BLEQ bcd_8
	POP {LR}
	
	CMP R8, #9
	PUSH {LR}
	BLEQ bcd_9
	POP {LR}
	
	MOV R0, R1
	PUSH {LR}
	BL PortQ_Output			     
	POP {LR}
	
	MOV R0, R4
	PUSH {LR}
	BL PortA_Output			     
	POP {LR}
	
	BX LR

bcd_0
	MOV R1, #2_1111	; abcd
	MOV R4, #2_00110000
	
	BX LR
	
bcd_1
	MOV R1, #2_0110	; abcd
	MOV R4, #2_00000000
	
	BX LR
	
bcd_2
	MOV R1, #2_1011	; abcd
	MOV R4, #2_01010000
	
	BX LR
	
bcd_3
	MOV R1, #2_1111	; abcd
	MOV R4, #2_01000000
	
	BX LR
	
bcd_4
	MOV R1, #2_0110	; abcd
	MOV R4, #2_01100000
	
	BX LR
	
bcd_5
	MOV R1, #2_1101	; abcd
	MOV R4, #2_01100000
	
	BX LR
	
bcd_6
	MOV R1, #2_1101	; abcd
	MOV R4, #2_01110000

	BX LR
	
bcd_7
	MOV R1, #2_0111	; abcd
	MOV R4, #2_00000000
	
	BX LR
	
bcd_8
	MOV R1, #2_1111	; abcd
	MOV R4, #2_01110000

	BX LR
	
bcd_9
	MOV R1, #2_1111	; abcd
	MOV R4, #2_01100000

	BX LR

	
passou_1s
	MOV R3, #0
	CMP R11, R12
	
	PUSH {LR}
	BGT aumentar_temp
	POP {LR}
	
	PUSH {LR}
	BLT diminuir_temp
	POP {LR}
	
	PUSH {LR}
	BEQ chegou_setpoint
	POP {LR}
	
	BX LR


chegou_setpoint
	
	; apaga o LED
	MOV R0, #2_00        
	PUSH {LR}
	BL PortN_Output			     
	POP {LR}
	
	; acende o PN0 e PN1
	MOV R0, #2_11
	PUSH {LR}  					 
	BL PortN_Output			     
	POP {LR}
	
	BX LR

aumentar_temp
	ADD R12, #1
	
	; apaga o LED
	MOV R0, #2_00        
	PUSH {LR}
	BL PortN_Output			     
	POP {LR}
	
	; acende o PN0
	MOV R0, #2_01
	PUSH {LR}  					 
	BL PortN_Output			     
	POP {LR}
	
	BX LR

diminuir_temp
	SUB R12, #1
	
	; apaga o LED
	MOV R0, #2_00        
	PUSH {LR}
	BL PortN_Output			     
	POP {LR}
	
	; acende o PN1
	MOV R0, #2_10
	PUSH {LR}  					 
	BL PortN_Output			     
	POP {LR}
	
	BX LR


sw_down
	LDR R10, =TEMP_MIN_TARGET
	CMP R11, R10
	PUSH {LR}
	BGT diminuir_setpoint
	POP {LR}
	
	BX LR

diminuir_setpoint
;	PUSH {LR}
;	BL Pisca_LED
;	POP {LR}
	
	SUB R11, #1
	
	BX LR


sw_up
	LDR R10, =TEMP_MAX_TARGET
	CMP R11, R10
	PUSH {LR}
	BLT aumentar_setpoint
	POP {LR}
	
	BX LR

aumentar_setpoint
;	PUSH {LR}
;	BL Pisca_LED
;	POP {LR}
	
	ADD R11, #1
	
	BX LR


Pisca_LED
	; acende o LED
	MOV R0, #2_01
	PUSH {LR}  					 ; empilha pra ter multiplas chamadas de funcao
	BL PortN_Output			     ; arg esta em R0
	POP {LR}
	
	; espera 100ms
	MOV R0, #100				 ; arg
	PUSH {LR}
	BL SysTick_Wait1ms			 ; arg esta em R0
	POP {LR}
	
	; apaga o LED
	MOV R0, #2_00          ; pra apagar o LED q acende com 2_00000010 => 2_000000(0)0
	PUSH {LR}
	BL PortN_Output			     ; arg esta em R0
	POP {LR}
	
	
	BX LR
	
	
	
	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
