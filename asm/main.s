; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 15/03/2018
; Este programa espera o usu�rio apertar a chave USR_SW1 e/ou a chave USR_SW2.
; Caso o usu�rio pressione a chave USR_SW1, acender� o LED2. Caso o usu�rio pressione 
; a chave USR_SW2, acender� o LED1. Caso as duas chaves sejam pressionadas, os dois 
; LEDs acendem.

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------

; -------------------------------------------------------------------------------
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2
		; Se alguma vari�vel for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a vari�vel <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma vari�vel de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posi��o da RAM		

TEMP_MAX_TARGET EQU 50 
TEMP_MIN_TARGET EQU 5
; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>
		EXPORT sw_up
		EXPORT sw_down
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms										
		IMPORT  GPIO_Init
        IMPORT  PortN_Output

; -------------------------------------------------------------------------------
; Fun��o main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO




	MOV R12, #15  ; temp_now
	MOV R11, #25  ; temp_target


MainLoop
;	Colocar a informa��o da dezena em PA7:PA4 e PQ3:PQ0  ; UDIV por 10 
;	Ativar o transistor Q2
;	Esperar 1ms
;	Desativar o transistor Q2
;	Esperar 1ms
;	Colocar a informa��o da unidade em PA7:PA4 e PQ3:PQ0  ; MLS
;	Ativar o transistor Q1
;	Esperar 1ms
;	Desativar o transistor Q1
;	Esperar 1ms
;	Colocar a informa��o dos LEDs em PA7:PA4 e PQ3:PQ0;
;	Ativar o transistor Q3Minist�rio da Educa��o
;	Esperar 1ms
;	Desativar o transistor Q3
;	Esperar 1ms

;	decrementar contador
;	se passou 1s, aumentar ou diminuir temperatural atual
;	reiniciar contador

;	se resfriando, acender PN1
;	se aquecendo, acender PN0
	

	B MainLoop
	
	
sw_down
	LDR R0, =TEMP_MIN_TARGET
	CMP R11, R0
	PUSH {LR}
	BGT diminuir_setpoint
	POP {LR}
	BX LR

diminuir_setpoint
	PUSH {LR}
	BL Pisca_LED
	POP {LR}
	
	ADD R11, #1
	
	BX LR


sw_up
	LDR R0, =TEMP_MAX_TARGET
	CMP R11, R0
	PUSH {LR}
	BLT aumentar_setpoint
	POP {LR}
	BX LR

aumentar_setpoint
	PUSH {LR}
	BL Pisca_LED
	POP {LR}
	
	SUB R11, #1
	
	BX LR


Pisca_LED
	; acende o LED
	MOV R0, #1
	PUSH {LR}  					 ; empilha pra ter multiplas chamadas de funcao
	BL PortN_Output			     ; arg esta em R0
	POP {LR}
	
	; espera 1000ms
	MOV R0, #100				 ; arg
	PUSH {LR}
	BL SysTick_Wait1ms			 ; arg esta em R0
	POP {LR}
	
	; apaga o LED
	MOV R0, #2_00000000          ; pra apagar o LED q acende com 2_00000010 => 2_000000(0)0
	PUSH {LR}
	BL PortN_Output			     ; arg esta em R0
	POP {LR}
	
	
	BX LR
	
	
	
	
    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo
