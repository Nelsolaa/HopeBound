extends CanvasLayer

# Variáveis para gerenciar o diálogo
var dialog_data = []  # Lista de diálogos no formato [{name, text}]
var current_dialog_index = 0
var typing_speed = 0.05  # Velocidade para simular digitação
var is_typing = false  # Flag para verificar se está digitando

# Referências aos nós
@onready var name_label: Label = $Panel/NameLabel
@onready var dialog_label: RichTextLabel = $Panel/DialogRichTextLabel
@onready var next_button: Button = $Panel/NextButton
@onready var panel: Panel = $Panel

func _ready():
	# Esconde o painel inicialmente
	panel.visible = false

# Função para iniciar o diálogo
func start_dialog(data: Array):
	dialog_data = data
	current_dialog_index = 0
	panel.visible = true
	show_dialog()

# Exibe o diálogo atual
func show_dialog():
	if current_dialog_index < dialog_data.size():
		var dialog = dialog_data[current_dialog_index]
		name_label.text = dialog["name"]  # Nome do personagem
		dialog_label.bbcode_text = ""  # Limpa o texto
		type_text(dialog["text"])
	else:
		close_dialog()
# Variáveis temporárias para armazenar o texto e o índice atual
var current_text = ""
var current_char_index = 0
# Função para digitar texto letra por letra
func type_text(text):
	is_typing = true
	current_text = text  # Armazena o texto atual
	current_char_index = 0  # Reseta o índice
	dialog_label.bbcode_text = ""  # Reseta o RichTextLabel
	var timer = Timer.new()
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start(typing_speed)
	
func _on_timer_timeout():
	if current_char_index < current_text.length():
		dialog_label.bbcode_text += current_text[current_char_index]
		current_char_index += 1
	else:
		is_typing = false
		get_node("Timer").queue_free()  # Remove o Timer

# Avança para o próximo diálogo
func next_dialog():
	if is_typing:
		# Mostra o texto completo instantaneamente se estiver digitando
		dialog_label.bbcode_text = dialog_data[current_dialog_index]["text"]
		is_typing = false
	else:
		# Avança para o próximo diálogo
		current_dialog_index += 1
		show_dialog()

# Fecha o sistema de diálogo
func close_dialog():
	panel.visible = false

# Input para avançar o diálogo
func _input(event):
	if event.is_action_pressed("ui_accept") and panel.visible:
		next_dialog()
