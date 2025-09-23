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
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms										
		IMPORT  GPIO_Init
        IMPORT  PortN_Output

; -------------------------------------------------------------------------------
; Função main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO




	MOV R12, #15  ; temp_now
	MOV R11, #25  ; temp_target


MainLoop
;	Colocar a informação da dezena em PA7:PA4 e PQ3:PQ0  ; UDIV por 10 
;	Ativar o transistor Q2
;	Esperar 1ms
;	Desativar o transistor Q2
;	Esperar 1ms
;	Colocar a informação da unidade em PA7:PA4 e PQ3:PQ0  ; MLS
;	Ativar o transistor Q1
;	Esperar 1ms
;	Desativar o transistor Q1
;	Esperar 1ms
;	Colocar a informação dos LEDs em PA7:PA4 e PQ3:PQ0;
;	Ativar o transistor Q3Ministério da Educação
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
	
	
	
	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
