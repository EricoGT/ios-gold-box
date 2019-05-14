//
//  OFMessages.h
//  Ofertas
//
//  Created by Marcelo Santos on 7/22/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

//splash info from server problem
#define ERROR_CONNECTION_TIMEOUT @"Tempo esgotado na comunicação com o servidor. Verifique sua conexão de dados e tente novamente."
//#define ERROR_CONNECTION_SPLASH @"Houve um erro ao obter as informações iniciais necessárias."
#define ERROR_CONNECTION_DATA @" Houve um problema com sua conexão. Verifique sua conexão de dados e tente novamente."
#define ERROR_CONNECTION_DATA_ERROR_JSON @"Houve um problema com sua requisição. Tente novamente mais tarde."
#define ERROR_CONNECTION_SPLASH @"Estamos com problemas no servidor. Tente novamente mais tarde."
//skin info from server problem
//#define ERROR_CONNECTION_SKIN @"Houve um erro ao obter as informações iniciais necessárias."
#define ERROR_CONNECTION_SKIN @"Estamos com problemas no servidor. Tente novamente mais tarde."
//#define ERROR_CONNECTION_PRODUCT @"Houve um erro ao obter as informações do produto."
#define ERROR_CONNECTION_PRODUCT @"Estamos com problemas no servidor. Tente novamente mais tarde."
//#define ERROR_CONNECTION_UNKNOWN @"Houve um erro desconhecido.\nPor favor, tente novamente mais tarde."
#define ERROR_CONNECTION_UNKNOWN @"Estamos com problemas no servidor. Tente novamente mais tarde."
//Internet error
//#define ERROR_CONNECTION_INTERNET @"Erro. Não há uma conexão ativa com a internet."
//#define ERROR_CONNECTION_INTERNET @"Sem conexão com a internet. Verifique se sua conexão 3g/Wi-Fi está disponível e tente novamente."
#define ERROR_CONNECTION_INTERNET @"Sem acesso a internet. Verifique sua conexão e tente novamente."
//NULL data after connection
//#define ERROR_CONNECTION_INVALID_DATA @"Estamos com problemas no servidor. Tente novamente mais tarde."
#define ERROR_CONNECTION_INVALID_DATA @"Estamos com problemas no servidor. Tente novamente mais tarde."
//Error parse or database
//#define ERROR_PARSE_DATABASE @"Erro na base de dados."
#define ERROR_PARSE_DATABASE @"Estamos com problemas no servidor. Tente novamente mais tarde."
//Error image download
//#define ERROR_CONNECTION_IMAGE  @"Falha no download da imagem."
#define ERROR_CONNECTION_IMAGE  @"Erro no download da imagem."
//Error product in stock
//#define ERROR_PRODUCT_NO_STOCK @"Este produto não está disponível no estoque."
#define ERROR_PRODUCT_NO_STOCK @"Este produto não está disponível no estoque."
//Error unzip file
//#define ERROR_UNZIP_FILE @"Erro na extração dos arquivos."
#define ERROR_UNZIP_FILE @"Erro na extração dos arquivos."

//#define SUCCESS_CONNECTION_INTERNET @"Conexão ativa com a internet."
#define SUCCESS_CONNECTION_INTERNET @"Conexão ativa com a internet."

//Error password or email
//#define ERROR_LOGIN_USERNAME_PASSWORD @"Usuário ou senha inválidos. Verifique se você os digitou corretamente e tente de novo."
#define ERROR_LOGIN_USERNAME_PASSWORD @"Usuário ou senha inválidos. Verifique se você os digitou corretamente e tente de novo"
#define ERROR_LOGIN_MAX_ATTEMPTS_REACHED @"Você atingiu o número máximo de tentativas de login. Tente novamente mais tarde."
#define LOGIN_INVALID_DATA @"E-mail, CPF ou CNPJ inválidos. Tente novamente."
#define PRIVACY_LOGIN_MESSAGE @"Nossa %@ foi atualizada. Ao continuar navegando em nosso aplicativo, você concorda com suas condições."
#define LOGIN_USE_TERMS @"Termos de Uso"
#define LOGIN_PRIVACY_TERMS @"Política de Privacidade"
//#define REGISTER_TERMS_MESSAGE @"Ao criar uma conta, você concorda com nossos %@, condições, %@ e que tem pelo menos 18 anos de idade."
#define REGISTER_TERMS_MESSAGE @"Ao entrar, você concorda com nossos %@, condições, %@ e que tem pelo menos 18 anos de idade."
#define REGISTER_TERMS_TEXT @"termos de uso"
#define REGISTER_PRIVACY_TEXT @"política de privacidade"
#define REGISTER_ERROR_MAX_ATTEMPTS_REACHED @"Você atingiu o número máximo de tentativas de cadastro. Tente novamente mais tarde."
#define LOGIN_INVALID_TITLE @"Ops! E-mail, CPF ou CNPJ inválido."
#define LOGIN_ERROR_TITLE @"Ops! Usuário ou senha inválidos"
#define LOGIN_ERROR_MESSAGE @"Usuário ou senha inválidos. Tente novamente."

//Unknown error from token
//#define ERROR_UNKNOWN_AUTH @"Problema com o token.\n\nPor favor, faça o login novamente."
#define ERROR_UNKNOWN_AUTH @"Aconteceu um problema na sua sessão.\nPor favor faça o login novamente."
//#define ERROR_CONNECTION_AUTH @"Estamos com problemas no servidor. Tente novamente mais tarde."
#define ERROR_CONNECTION_AUTH @"Estamos com problemas no servidor. Tente novamente mais tarde."

#define ERROR_CONNECTION_AUTH_COMPLEMENT @"Sua sessão expirou. Você será redirecionado ao carrinho para poder finalizar o seu pedido."

//Unknown error get Ship Address
//#define ERROR_UNKNOWN_SHIPADD @"Unknown error from server. Request Shipment Address failed."
#define ERROR_UNKNOWN_SHIPADD @"Estamos com problemas no servidor. Tente novamente mais tarde."
//#define ERROR_CONNECTION_SHIPADD @"Estamos com problemas no servidor. Tente novamente mais tarde."
#define ERROR_CONNECTION_SHIPADD @"Estamos com problemas no servidor. Tente novamente mais tarde."

//No ship address
//#define ERROR_NO_SHIPADD @"Você não possui nenhum endereço cadastrado. Utilize a opção acima para adicionar um endereço."
#define ERROR_NO_SHIPADD @"Você não possui nenhum endereço cadastrado. Adicione um endereço para continuar."

//Recover Password
#define RESET_PASSWORD_EMPTY @"Digite um E-mail, CPF ou CNPJ válido."
#define NOT_REGISTERED_PASSWORD_RECOVER @"E-mail, CPF ou CNPJ não cadastrado. Verifique se você os digitou corretamente"
#define SUCCESS_PASSWORD_RECOVER @"Você receberá um e-mail com o link e instruções para criar uma nova senha no walmart.com."
#define SUCCESS_PASSWORD_RECOVER_FORMAT @"Você receberá um e-mail em %@ com o link e instruções para criar uma nova senha no walmart.com"
#define ERROR_CONNECTION_RECOVER @"Estamos com problemas no servidor. Tente novamente mais tarde."
#define ERROR_UNKNOWN_RECOVER @"Estamos com problemas no servidor. Tente novamente mais tarde."
#define PWD_RECOVER_SUCCESS_FORMAT @"Sucesso! Você receberá um e-mail em %@ com instruções para criar uma nova senha."

//Basket
//#define EMPTY_CART @"Seu carrinho está vazio."
#define EMPTY_CART @"Seu carrinho está vazio"

//Product Category Screen
//#define ERROR_CONNECTION_CATEGORY @"Estamos com problemas no servidor. Tente novamente mais tarde."
#define ERROR_CONNECTION_CATEGORY @"Estamos com problemas no servidor. Tente novamente mais tarde."
//#define ERROR_UNKNOWN_CATEGORY @"Estamos com problemas no servidor. Tente novamente mais tarde."
#define ERROR_UNKNOWN_CATEGORY @"Estamos com problemas no servidor. Tente novamente mais tarde."

//Feedback
//#define FEEDBACK_HELP_MESSAGE @"Envie sua nota e nos mande as suas sugestões"
#define FEEDBACK_HELP_MESSAGE @"Gostou do aplicativo?\n Envie sua avaliação e sugestões."
//#define ERROR_SEND_FEEDBACK @"Não foi possível enviar o seu feedback :(\nPor favor, tente novamente"
#define ERROR_SEND_FEEDBACK @"Não foi possível enviar a sua opinião.\nTente novamente."

//Shipping Options Parser
#define ERROR_PARSER_SHIPPING_OPTIONS @"Não foi possivel obter as opções de entrega."

//Address
//#define NEW_ADDRESS_ERROR @"Não foi possível adicionar esse endereço.\nPor favor, tente novamente"
#define NEW_ADDRESS_ERROR @"Não foi possível adicionar esse endereço.\nTente novamente."
//#define UPDATE_ADDRESS_ERROR @"Erro ao alterar os dados do endereço.\nPor favor, tente novamente"
#define UPDATE_ADDRESS_ERROR @"Aconteceu um erro ao editar os dados de endereço. Tente novamente."
//#define ZIPCODE_ERROR @"Erro ao obter as informações do CEP.\nPor favor, tente novamente"
#define ZIPCODE_ERROR @"Aconteceu um erro ao obter as informações de CEP. Tente novamente."
//#define ZIPCODE_NOTFOUND_ERROR @"CEP não encontrando.\nPor favor, insira um CEP válido"
#define ZIPCODE_NOTFOUND_ERROR @"CEP não encontrado.\nVerifique se você o digitou corretamente."
//#define ZIPCODE_INVALID_ERROR @"O CEP deve possuir exatamente 8 dígitos"
#define ZIPCODE_INVALID_ERROR @"O CEP deve conter 8 digitos. Verifique se você o digitou corretamente."
//#define SHIPMENTS_ERROR @"Erro ao obter os valores de frete.\nPor favor, tente novamente"
#define SHIPMENTS_ERROR @"Não há rotas disponíveis para o CEP informado."
//#define ZIPCODE_INVALID_MESSAGE @"Por favor, insira um CEP válido"
#define ZIPCODE_INVALID_MESSAGE @"CEP inválido. Verifique se você o digitou corretamente."
//#define ZIPCODE_CHANGED @"Por favor, toque no botão Pesquisar para que os dados sejam atualizados de acordo com o seu CEP.";
#define ZIPCODE_CHANGED @"Toque no botão Pesquisar para que os dados sejam atualizados de acordo com o seu CEP."

//Simulate
//#define ERROR_SHOPPING_CART @"Estamos com problemas no servidor. Tente novamente mais tarde."
#define ERROR_SHOPPING_CART @"Estamos com problemas no servidor. Tente novamente mais tarde."
#define ERROR_CONNECTION_SHOPPING @"Estamos com problemas no servidor. Tente novamente mais tarde."
//#define SERVER_RETURNED_INFERIOR_PRICE @"Você ganhou desconto extra! Confira suas ofertas."
#define SERVER_RETURNED_INFERIOR_PRICE @"Você ganhou desconto extra! Confira suas ofertas."
//#define SERVER_RETURNED_SUPERIOR_PRICE @"Sua compra sofreu alteração nos preços. Verifique antes de continuar."
#define SERVER_RETURNED_SUPERIOR_PRICE @"Sua compra sofreu alteração nos preços. Verifique antes de continuar."
//#define ERROR_QUANTITY_AVAILABLE @"A quantidade do produto não está disponível."
#define ERROR_QUANTITY_AVAILABLE @"A quantidade de um ou mais produtos não está disponível. Altere a quantidade antes de continuar."
//#define PRODUCT_NOT_AVAILABLE @"Produto não disponível. Por favor, remova o produto do carrinho."
#define PRODUCT_NOT_AVAILABLE @"Um ou mais produtos não estão disponíveis. Remova o(s) produto(s) do carrinho antes de continuar."
#define PRODUCT_PRICE_DIVERGENT @"O preço deste produto mudou"
#define PRODUCT_PRICE_HIGH @"O preço deste produto aumentou"
#define PRODUCT_PRICE_LOW @"O preço deste produto diminuiu"
#define ERROR_PRODUCT_QUANTITY_AVAILABLE @"A quantidade escolhida para este produto não está disponível. Altere a quantidade para continuar."

//User
//#define UPDATE_USER_ERROR @"Erro ao completar o cadastro.\nPor favor, tente novamente"
#define UPDATE_USER_ERROR @"Aconteceu um erro ao completar o cadastro. Tente novamente."
//#define CREATE_USER_ERROR @"Erro no cadastro.\nPor favor, tente novamente"
#define CREATE_USER_ERROR @"Aconteceu um erro ao criar o cadastro. Tente novamente."

//Shipment Options
//#define SHIPMENT_DATE_OPTIONS @"Selecione um tipo de entrega."
#define SHIPMENT_DATE_OPTIONS @"Selecione um tipo de entrega."
//#define SHIPMENT_DATE_SCHEDULE @"Escolha uma data para o agendamento."
#define SHIPMENT_DATE_SCHEDULE @"Escolha uma data para agendar a entrega."
//#define SHIPMENT_DATE_CHOOSE @"Escolha a data que deseja para a entrega."
#define SHIPMENT_DATE_CHOOSE @"Escolha uma data para agendar a entrega."
//#define SHIPMENT_PERIOD_CHOOSE @"Escolha o período que deseja a entrega."
#define SHIPMENT_PERIOD_CHOOSE @"Escolha um período para agendar a entrega."
#define SHIPMENT_VALUE_FREE @"Grátis"

//Shippings
//#define ERROR_CONNECTION_SHIPPINGS @"Estamos com problemas no servidor. Tente novamente mais tarde."
#define ERROR_CONNECTION_SHIPPINGS @"Estamos com problemas no servidor. Tente novamente mais tarde."
//#define ERROR_SHIPPINGS @"Estamos com problemas no servidor. Tente novamente mais tarde."
#define ERROR_SHIPPINGS @"Estamos com problemas no servidor. Tente novamente mais tarde."
//#define ERROR_DIFFERENT_VALUES @"Sua compra sofreu alteração nos preços. Verifique antes de continuar."
#define ERROR_DIFFERENT_VALUES @"Sua compra sofreu alteração nos preços. Verifique antes de continuar."
#define ERROR_SHIPPING_ROUTE @"Não é possível entregar no endereço informado."

//Installments
#define ERROR_CONNECTION_INSTALLMENTS @"Estamos com problemas no servidor. Tente novamente mais tarde."

//Payment
#define CREDIT_CARD_NOT_SET @"Informe o número do seu cartão de crédito"
#define CREDIT_CARD_NO_SELECTED @"Selecione a bandeira do seu cartão de crédito"
//Combo Picker Credit Card Payment
#define CREDIT_CARD_SELECT_INSTALMMENTS @"Número de Parcelas"
#define CREDIT_CARD_SELECT_MONTH @"Mês do Cartão de Crédito"
#define CREDIT_CARD_SELECT_YEAR @"Ano do Cartão de Crédito"

//#define ERROR_CNPJ_CPF @"Número de documento inválido."
#define ERROR_CNPJ_CPF @"CPF ou CNPJ inválido. Verifique se você o digitou corretamente"
//#define ERROR_CREDIT_CARD @"Cartão de crédito inválido. Verifique se a bandeira correta do cartão está selecionada."
#define ERROR_CREDIT_CARD @"Cartão de crédito inválido. Verifique se as informações do seu cartão estão corretas"
#define ERROR_READING_CREDIT_CARD @"Utilize um cartão de crédito válido."

//Self help credit card
#define SELF_HELP_CREDITCARD_ERROR_EXCLUDING_CARD @"Não foi possível excluir o cartão. Tente novamente."
#define SELF_HELP_CREDITCARD_SUCCESS_EXCLUDING_CARD @"Cartão excluído com sucesso!"

#define SELF_HELP_CREDITCARD_ERROR_SETTING_DEFAULT_CARD @"Não foi possível atualizar o cartão como principal. Tente novamente."
#define SELF_HELP_CREDITCARD_SUCCESS_SETTING_DEFAULT_CARD @"Cartão principal atualizado com sucesso!"
#define SELF_HELP_CREDITCARD_SUCCESS_ADD @"Cartão adicionado com sucesso!"
#define SELF_HELP_CREDITCARD_SUCCESS_ADD_ERROR @"Não foi possível adicionar o cartão. Tente novamente."
#define SELF_HELP_CREDITCARD_SUCCESS_ADD_ERROR_REPEAT_CARD @"Ops! Este cartão já está cadastrado em nosso sistema!"


//Nome do dono do cartão de crédito
//#define ERROR_NAME @"Nome incompleto."
#define ERROR_NAME @"Nome inválido. Verifique se você o digitou corretamente"
//#define ERROR_SEC_CCARD @"O código de segurança do cartão de crédito deve ser informado."
#define ERROR_SEC_CCARD @"O campo Código CVV deve ser preenchido"
//#define ERROR_MONTH_CCARD @"O mês de validade do cartão deve ser informado."
#define ERROR_MONTH_CCARD @"Selecione o mês de validade do cartão de crédito"
//#define ERROR_YEAR_CCARD @"O ano de validade do cartão de crédito deve ser informado."
#define ERROR_YEAR_CCARD @"Selecione o ano de validade do cartão de crédito"
#define ERROR_EXPIRATION_DATE_CCARD @"Cartão vencido ou data de validade incorreta."
//#define ERROR_INSTALLMENTS @"Uma forma de pagamento deve ser escolhida."
//#define ERROR_INSTALLMENTS @"Selecione uma forma de pagamento."
//#define ERROR_INSTALLMENTS @"Todos os campos devem estar preenchidos."
#define ERROR_INSTALLMENTS @"Selecione a quantidade de parcelas desejada"
//#define ERROR_CONNECTION_INSTALLMENTS @"Estamos com problemas no servidor. Tente novamente mais tarde."
#define ERROR_CONNECTION_INSTALLMENTS @"Estamos com problemas no servidor. Tente novamente mais tarde."
//#define ERROR_VALIDATE_CCARD @"A data de validade do cartão é inválida. A data deve ser igual ou superior ao mês/ano atual."
#define ERROR_VALIDATE_CCARD @"A validade deve ser igual ou superior ao mês/ano atual. Verifique se você a digitou corretamente"

//Place Order
//#define ERROR_CONNECTION_PO @"Estamos com problemas no servidor. Tente novamente mais tarde."
#define ERROR_CONNECTION_PO @"Estamos com problemas no servidor. Tente novamente mais tarde."
#define ERROR_PO @"Estamos com problemas no servidor. Tente novamente mais tarde."

//Greetings
#define GREETING_HI @"Olá"

//Ops
#define GREETING_OPS @"Ops!"
#define GREETING_OPS_SAD @"Ops :("

//Stock out product
#define PRODUCT_NO_STOCK @"Este produto esgotou"

//Product Detail
#define PRODUCT_PRICE_START @"A partir de"
#define PRODUCT_PRICE_FROM @"Por"
#define PRODUCT_UNAVAILABLE @"Produto temporariamente indisponível"
#define PRODUCT_UNAVAILABLE_MAILME @"Avise-me quando estiver disponível"
#define PRODUCT_QTY_EDIT @"Quantidade"
#define PRODUCT_BUY_BUTTON @"Comprar"
#define PRODUCT_VARIATIONS_NO_CHOOSED @"Antes de comprar, selecione uma opção para o produto."
#define PRODUCT_FAVORITE_VARIATIONS_NO_CHOOSED @"Antes de adicionar aos Favoritos, selecione a opção do produto."
#define PRODUCT_PRICE_FULL @"Preço do produto"
#define PRODUCT_TAX_IMPORT @"Taxa de importação"
#define PRODUCT_CART_ITEM_OVERFLOW @"Você atingiu a quantidade máxima de itens para esse produto."
#define PRODUCT_CART_OVERFLOW @"Você atingiu o número máximo de produtos no carrinho."
#define PRODUCT_PAYMENT_FORMS_BANK_SLIP_MESSAGE @"Efetue o pagamento do boleto pela internet ou em bancos, lotéricas ou correios. Quanto mais rápido você pagar, mais cedo a sua compra deve chegar. O boleto não será enviado via correios."

//Invalids
//#define INVALID_BIRTHDAY @"Por favor, insira uma data de nascimento válida"
#define INVALID_BIRTHDAY @"Insira uma data de nascimento válida."
//#define INVALID_MOBILE_NUMBER @"Por favor, insira um celular válido"
#define INVALID_MOBILE_NUMBER @"Insira um telefone celular válido."
//#define INVALID_TELEPHONE_NUMBER @"Por favor, insira um telefone válido"
#define INVALID_TELEPHONE_NUMBER @"Insira um telefone válido."

#define INVALID_CPF @"Insira um CPF válido."
#define INVALID_DOCUMENT_REGISTER @"Insira um CPF/CNPJ válido."
//#define INVALID_CNPJ @"Por favor, insira um CNPJ válido"
#define INVALID_CNPJ @"Insira um CNPJ válido."

#define INVALID_CPF_CNPJ @"Insira um CPF/CNPJ válido."

#define INVALID_DOCUMENT @"Insira um documento válido."
#define INVALID_BIRTHDAY @"Insira uma data de nascimento válida."
#define INVALID_PHONE @"Insira um ou mais telefones válidos."

//#define INVALID_EMAIL @"Por favor, insira um e-mail válido"
#define INVALID_EMAIL @"Insira um e-mail válido."
//#define INVALID_NAME @"Por favor, insira um nome válido"
#define INVALID_NAME @"Insira um nome válido."
//#define INVALID_SIZE_PASSWORD_6 @"A senha deve conter ao menos 6 caracteres."
#define INVALID_SIZE_PASSWORD_6 @"A senha deve conter pelo menos 6 caracteres."
#define INVALID_PWD @"Ops! Senha inválida."
#define REGISTER_INVALID_SIZE_PWD @"A senha deve ter no mínimo 8 caracteres."
//#define EMPTY_EMAIL @"Por favor, preencha o campo email"
#define LOGIN_EMPTY_EMAIL @"Preencha o campo E-mail, CPF ou CNPJ."
//#define EMPTY_PASS @"Por favor, preencha o campo senha"
#define LOGIN_EMPTY_PASS @"Preencha o campo Senha."
//#define EMPTY_EMAIL_AND_PASS @"Por favor, preencha os campos de e-mail e senha"
#define LOGIN_EMPTY_EMAIL_AND_PASS @"Preencha os campos E-mail, CPF ou CNPJ e senha"
#define EMPTY_DOCUMENT @"Preencha o campo CPF/CNPJ"
//#define EMPTY_COMPLETE_NAME @"Por favor, preencha o campo nome completo"
#define EMPTY_PHONE @"Insira pelo menos um telefone."
#define EMPTY_COMPLETE_NAME @"Preencha o campo Nome completo."
#define EMPTY_NAME @"Preencha o campo Nome."
#define EMPTY_EMAIL @"Preencha o campo E-mail."
#define EMPTY_GENERAL @"Preencha o"
#define EMPTY_LABEL_NAME @"campo nome."
#define EMPTY_LABEL_ADDRESS_TYPE @"tipo de endereço."
#define EMPTY_LABEL_STREET @"endereço."
#define EMPTY_LABEL_NEIGHBORHOOD @"bairro."
#define EMPTY_LABEL_NUMBER @"número do endereço."
#define EMPTY_LABEL_ZIPCODE @"CEP."
#define UNAVAILABLE_SAVE_SUCCESS @"Email cadastrado com sucesso! Em breve você será avisado."

#define EMAIL_ALREADY @"Este E-mail está cadastrado"
#define CPF_ALREADY @"Este CPF ou CNPJ já está cadastrado."

#define TRY_BUTTON @"Tentar novamente"
#define TRY_BUTTON_SIMPLE @"Tentar"
#define EXCLUDE_BUTTON @"Excluir"
#define CANCEL_BUTTON @"Cancelar"
#define CONTINUE_BUTTON @"Continuar"
#define OK_BUTTON @"OK"

#define MSG_DELETE_ADDRESS @"Deseja excluir este endereço?"

#define INVALID_NAME_DESTINY @"Nome do destinatário inválido."

#define GO_OUT_APP_FROM_TERMS_TITLE @"Sair do aplicativo"
#define GO_OUT_APP_FROM_TERMS @"Ao sair do aplicativo você pode perder o seu carrinho. Tem certeza que deseja sair do aplicativo?"

#define ERROR_GENERAL_SELLER @"Ocorreu um erro, entre em contato ou tente mais tarde."

//Error 401 checkout
#define ERROR_401_CHECKOUT @"Sua sessão expirou, reinicie o seu processo de compra novamente."

//Tracking
#define ERROR_ORDERS @"Não foi possível carregar os seus pedidos"
#define ERROR_MY_ACCOUNT @"Falha ao obter os seus pedidos"
#define EMPTY_ORDERS @"Você não tem pedidos no Walmart.com"
#define MY_ACCOUNT_TITLE @"Minha conta"
#define ORDERS_TITLE @"Pedidos"
#define ERROR_ORDER_STATUS_DETAIL @"Falha ao obter os detalhes do status desse pedido"
#define NO_CONTENT_DESCRIPTION @"Não há uma descrição para este produto"
#define NO_CONTENT_SPECIFICATION @"Não há uma especificação para este produto"
#define DELIVERY_DATE_MESSAGE @"Previsão de entrega: %@"
#define TRACKING_INVOICE_SEND_EMAIL @"Enviar nota por e-mail"
#define TRACKING_INVOICE_SEE @"Visualizar nota fiscal"
#define TRACKING_INVOICE_PDF_TITLE @"Nota fiscal"
#define TRACKING_INVOICE_PDF_ERROR @"Não foi possível recuperar a Nota Fiscal"
#define TRACKING_WAITING_PAYMENT_BARCODE @"OPS! Ainda não identificamos o pagamento do seu boleto :("
#define TRACKING_VIEW_BARCODE_TITLE @"Boleto Bancário"
#define TRACKING_INSTALLMENTS_RATE_MESSAGE @"Importante: Para financiamento com juros de %@ a.m. CET máximo de %@ a.a. (cobrado pela operadora de cartão de crédito)"

//Checkout errors mapped
#define PLC0116 @"Você ainda não tem um CPF cadastrado."
#define PLC0120 @"Erro ao realizar a sua solicitação. Por favor, tente novamente."
#define PLC0201 @"Produto não está disponível, verifique o carrinho novamente."
#define PLC0202 @"Produto não está disponível, verifique o carrinho novamente."
#define PLC0213 @"O valor do frete mudou, verifique o carrinho novamente."
#define PLC0214 @"O valor dos produtos mudou, verifique o carrinho novamente."
#define PLC0215 @"O valor dos produtos mudou, verifique o carrinho novamente."
#define PLC0219 @"Este cartão não foi aceito. Por favor, escolha outra forma de pagamento."
#define LGT0115 @"Produto não está disponível, verifique o carrinho novamente."
#define LGT030X @"Janela de entrega inválida."
#define LGT0402 @"Não é possível entregar no endereço informado."
#define SNP0036 @"O produto que você escolheu está armazenado em um Centro de Distribuição que não realiza vendas para Pessoas Jurídicas."
#define PREAUTH @"Este cartão não foi aceito. Por favor, escolha outra forma de pagamento."

#define CARD_SCANNER_CAMERA_ERROR @"Não foi possível abrir a câmera para escanear o cartão"
#define CARD_SCANNER_CAMERA_DENIED_TITLE @"Permissão para câmera"
#define CARD_SCANNER_CAMERA_DENIED_MESSAGE @"Para utilizar o leitor de cartão, permita que o app acesse a câmera. Toque em Ajustes e ative a Câmera."
#define CARD_SCANNER_CAMERA_DENIED_CANCEL @"Agora não"
#define CARD_SCANNER_CAMERA_DENIED_SETTINGS @"Ajustes"

//Notify me
#define EMPTY_EMAIL_AND_NAME_NOTIFY @"Informe o nome e email."

//Labels
#define LBL_CART_TITLE @"Carrinho"
#define COMUNICATION_ERROR @"Erro de comunicação"
#define REQUEST_ERROR @"Houve um problema com sua requisição."

//Rating
#define RATING_MESSAGE_TITLE @"Avalie nosso app :-) "
#define RATING_MESSAGE_TEXT @"Está gostando do aplicativo Walmart.com?/nSua opinião nos permite melhorar a experiência e ajuda outras pessoas a descobrirem nosso app./nQue tal nos avaliar na loja?"

#define ORDER_EMPTY_MESSAGE_WITH_TERM @"Não é possivel ordenar sua busca. Procuramos por %@ e não encontramos nenhum resultado"
#define ORDER_EMPTY_MESSAGE_WITHOUT_TERM @"Não é possivel ordenar sua busca. Não encontramos nenhum resultado"
#define FILTER_EMPTY_MESSAGE_WITH_TERM @"Não é possivel refinar sua busca. Procuramos por %@ e não encontramos nenhum resultado"
#define FILTER_EMPTY_MESSAGE_WITHOUT_TERM @"Não é possivel refinar sua busca. Não encontramos nenhum resultado"

#define ERROR_HOME_FOOTER @"Não foi possível carregar o conteúdo da errata"

#define PROTOCOL_EXTENDED_WARRANTY_MESSAGE @"O bilhete do seguro foi enviado para o seu e-mail e esse é o número de protocolo dessa operação: %@"

#define EXTENDED_WARRANTY_ERROR_OPTIONS_NO_SELECTED @"Ops! Você deve selecionar uma opção"

#define EXTENDED_WARRANTY_LICENSE_ERROR @"Não foi possível carregar este conteúdo."

#define EXTENDED_WARRANTY_SEPARATE_PAYMENT @"Autorizo que o pagamento do Seguro Garantia Estendida Original seja realizado  conjunto com o pagamento(s) do(s) produto(s)/serviço(s) adquirido(s)."

//Notifications
#define NOTIFICATIONS_HEADER @"Notificações do aplicativo para:"
#define NOTIFICATIONS_OFFERS_TEXT @"Receber ofertas e acompanhar os seus pedidos"
#define NOTIFICATIONS_WARNING_TITLE @"Lembrete:"
#define NOTIFICATIONS_WARNING_MESSAGE @"Habilite as notificações em Ajustes > Notificações e ligue-as para o app Walmart.com"

//Personal Data
#define PERSONAL_DATA_WARNING_NAME @"Informe seu nome e sobrenome"
#define PERSONAL_DATA_WARNING_SEX @"Selecione seu sexo"
#define PERSONAL_DATA_WARNING_BIRTH_DATE @"Informe a data de nascimento"
#define PERSONAL_DATA_WARNING_TELEPHONE @"Informe seu telefone"
#define PERSONAL_DATA_WARNING_INVALID_TELEPHONE @"Telefone inválido"
#define PERSONAL_DATA_WARNING_INVALID_TELEPHONE_LOCAL @"Telefone fixo inválido"
#define PERSONAL_DATA_WARNING_INVALID_TELEPHONE_CELL @"Telefone celular inválido"
#define PERSONAL_DATA_WARNING_EMAIL @"Informe um e-mail válido"
#define PERSONAL_DATA_SUCCESS_SAVE @"Dados atualizados"
#define PERSONAL_DATA_ERROR_SAVE @"Erro ao atualizar dados. Verifique as informações e tente novamente."
#define PERSONAL_DATA_ERROR_EXISTS @"Este número de documento já existe."

//New/Edit Address

#define ADDRESS_WARNING_NAME @"Informe seu nome e sobrenome"
#define ADDRESS_WARNING_ADDRESS_TYPE @"Selecione o tipo de endereço"
#define ADDRESS_WARNING_STREET @"Informe seu endereço"
#define ADDRESS_WARNING_NEIGHBORHOOD @"Informe seu bairro"
#define ADDRESS_WARNING_NUMBER @"Informe seu número"
#define ADDRESS_WARNING_ZIP @"Erro ao buscar cep"
#define ADDRESS_SUCCESS_UPDATE @"Endereço atualizado"
#define ADDRESS_SUCCESS_ADD @"Endereço adicionado"
#define ADDRESS_ERROR_SAVE @"Erro ao enviar o endereço"
#define ADDRESS_WARNING_ZIP_CODE @"Informe seu CEP"
#define ADDRESS_ERROR_SAVE_DEFAULT @"Erro ao definir o endereço principal. Tente novamente."
#define ADDRESS_SUCCESS_SAVE_DEFAULT @"Endereço principal atualizado com sucesso!"

//Change Password
#define CHANGE_PASSWORD_WARNING_CURRENT_PASS @"Informe a senha atual."
#define CHANGE_PASSWORD_WARNING_NEW_PASS @"Entre com a nova senha."
#define CHANGE_PASSWORD_WARNING_MIN_LENGTH @"A nova senha deve ter no mínimo 8 caracteres."
#define CHANGE_PASSWORD_WARNING_CONFIRM_PASS @"Confirme a nova senha."
#define CHANGE_PASSWORD_WARNING_DISTINCT_PASS @"As senhas não conferem."
#define CHANGE_PASSWORD_SUCCESS @"Senha alterada com sucesso!"
#define CHANGE_PASSWORD_ERROR @"Erro ao alterar senha."

//Change Email
#define CHANGE_EMAIL_WARNING_INVALID @"Informe um e-mail válido"
#define CHANGE_EMAIL_WARNING_SAME @"Novo e-mail deve ser diferente do atual"
#define CHANGE_EMAIL_WARNING_PASSWORD @"Informe sua senha"
#define CHANGE_EMAIL_SUCCESS @"E-mail atualizado"
#define CHANGE_EMAIL_ERROR @"Erro ao alterar e-mail"
#define CHANGE_EMAIL_ERROR_ALREADY_EXISTS @"E-mail já existe"

//My Addresses
#define MY_ADDRESSES_MAIN_ADDRESS_TEXT @"Endereço Principal"
#define MY_ADDRESSES_DELETE_SUCCESS @"Endereço excluído"
#define MY_ADDRESSES_DELETE_ERROR @"Erro ao excluir o endereço"
#define MY_ADDRESSES_NEW_ADDRESS_TITLE @"Adicionar endereço"
#define MY_ADDRESSES_EDIT_ADDRESS_TITLE @"Editar endereço"

//Phone calls
#define DEVICE_CANT_PLACE_PHONE_CALL @"Não é possível realizar ligações com esse dispositivo."
#define DEVICE_WITHOUT_SIM_CARD @"Não existe um cartão SIM instalado."

//Extended Warranty Card Cell
#define EXTENDED_WARRANTY_TICKET_TITLE @"Nº do bilhete:"
#define EXTENDED_WARRANTY_ACCESSION_DATE_TITLE @"Data de adesão:"
#define EXTENDED_WARRANTY_CANCELLED_TITLE @"Cancelada em"
#define EXTENDED_WARRANTY_COVERAGE_TITLE @"Vigência de cobertura:"
#define EXTENDED_WARRANTY_LICENSE_COVERAGE_DATE_SEPARATOR @"à"

//Extended Warranty
#define EXTENDED_WARRANTY_LIST_HEADER_TITLE @"Produtos com Seguro Garantia Estendida Original"
#define EXTENDED_WARRANTY_LIST_TITLE @"Garantias Estendidas"
#define EXTENDED_WARRANTY_DETAILS_TITLE @"Detalhes"
#define EXTENDED_WARRANTY_CANCEL_TITLE @"Cancelar seguro"
#define EXTENDED_WARRANTY_LIST_NO_WARRANTIES @"Você ainda não tem nenhum Seguro Garantia Estendida Original"

#define EXTENDED_WARRANTY_DETAIL_PARSER_ERROR @"Não foi possível exibir os detalhes do Seguro Garantia Estendida Original"
#define EXTENDED_WARRANTY_DETAIL_TICKET_TITLE @"Bilhete de seguro nº %@"
#define EXTENDED_WARRANTY_DETAIL_ENROLLMENT_TITLE @"Data de adesão:"
#define EXTENDED_WARRANTY_DETAIL_START_DATE_TITLE @"Vigência da cobertura:"
#define EXTENDED_WARRANTY_DETAIL_CANCEL_TITLE @"Cancelado em:"
#define EXTENDED_WARRANTY_DETAIL_ADDRESS_TITLE @"Contrato enviado para:"
#define EXTENDED_WARRANTY_DETAIL_VALUE_TITLE @"Valor total: %@"
#define EXTENDED_WARRANTY_CANCEL_PROTOCOL_MESSAGE @"O cancelamento desse Seguro Garantia Estendida Original já foi solicitado. O protocolo é o %@. Por favor, aguarde a confirmação."

#define EXTENDED_WARRANTY_DETAIL_OPTION_SEE_TICKET @"Emitir bilhete"
#define EXTENDED_WARRANTY_DETAIL_OPTION_AUTORIZATION @"Termo de autorização"
#define EXTENDED_WARRANTY_DETAIL_OPTION_CANCEL @"Cancelar seguro"
#define EXTENDED_WARRANTY_DETAIL_OPTION_CANCELLED @"Termo de cancelamento"

#define EXTENDED_WARRANTY_PDF_TICKET_TITLE @"Bilhete"
#define EXTENDED_WARRANTY_PDF_ENROLLMENT_TITLE @"Termo de autorização"
#define EXTENDED_WARRANTY_PDF_RESCISSION_TITLE @"Termo de recisão"
#define EXTENDED_WARRANTY_WARNING_REASON @"Informe um motivo"
#define EXTENDED_WARRANTY_WARNING_OPTION @"Informe qual opção deseja"
#define EXTENDED_WARRANTY_WARNING_ACCOUNT_OPTION @"Informe se tem conta bancária"
#define EXTENDED_WARRANTY_WARNING_BANK @"Informe o banco"
#define EXTENDED_WARRANTY_WARNING_AGENCY @"Informe a agência"
#define EXTENDED_WARRANTY_WARNING_ACCOUNT @"Informe a conta"
#define EXTENDED_WARRANTY_WARNING_DOCUMENT @"Informe seu RG"
#define EXTENDED_WARRANTY_BANK_ACCOUNT_YES @"Tenho conta bancária"
#define EXTENDED_WARRANTY_BANK_ACCOUNT_NO @"Não tenho conta bancária"
#define EXTENDED_WARRANTY_REFUND_BANK_MESSAGE @"Atenção: Se você efetuou o pagamento do seu pedido através de Débito em Conta ou Boleto Bancário e deseja realizar o reembolso, nos ajude informando seus dados bancários. O CPF do titular da conta corrente deve ser o mesmo CPF do cliente que efetivou a compra no site do Walmart."
#define EXTENDED_WARRANTY_REFUND_DOCS_MESSAGE @"Atenção: O pagamento será feito através de ordem de pagamento disponibilizado nas agências do Banco do Brasil"
#define EXTENDED_WARRANTY_CANCEL_ERROR @"Erro ao solicitar o cancelamento do Seguro Garantia Estendida Original"
#define EXTENDED_WARRANTY_CANCEL_SUCCESS @"Solicitação de cancelamento enviada com sucesso"

//HUB
#define HUB_MENU_TITLE_CATEGORIES @"Categorias"
#define HUB_MENU_TITLE_OFFERS @"Ofertas"
#define HUB_EMPTY_OFFERS @"Nenhuma oferta disponível no momento"
#define HUB_OFFERS_ERROR @"Não foi possível carregar as ofertas"

//Image not available
#define IMAGE_UNAVAILABLE_NAME @"ic_image_unavaiable"
#define IMAGE_UNAVAILABLE_NAME_2 @"img_product_unavailable.jpg"
#define IMAGE_UNAVAILABLE_NAME_3 @"img_product_unavailable_collection"
#define IMAGE_UNAVAILABLE_NEW @"ic_no_photo"

//Contact
#define CONTACT_SCHEDULE @"Horário de atendimento\nDe Segunda a Sábado das 8h às 20h\nDomingo das 8h às 18h."
#define CONTACT_REQUEST_REQUEST_ERROR @"Houve um problema com sua requisição. Tente novamente mais tarde."
#define CONTACT_REQUEST_ORDER_DELIVERIES_PARSER_ERROR @"Não foi possível carregar os detalhes do seu pedido"
#define CONTACT_REQUEST_EXCHANGE_FIELDS_PARSER_ERROR @"Não foi possível carregar o formulário de Troca e Devolução"
#define CONTACT_REQUEST_NO_ELIGIBLE_ORDERS @"Sem pedidos elegíveis"
#define CONTACT_REQUEST_ALERT_SELECT_PRODUCTS @"Selecione o produto"
#define CONTACT_REQUEST_ALERT_INCOMPLETE_FORM @"Preencha todos os campos"
#define CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_SUBJECT @"Preencha o campo Motivo";
#define CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_DESCRIPTION @"O comentário deve ter no mínimo 10 caracteres";
#define CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_USERNAME @"Preencha o campo Nome";
#define CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_CPF @"Preencha o campo CPF";
#define CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_EMAIL @"Preencha o campo E-mail";
#define CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_TELEPHONE @"Preencha o campo Telefone";
#define CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_BANK_NAME @"Preencha o campo Banco";
#define CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_BANK_BRANCH @"Preencha o campo Agência";
#define CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_ACCOUNT_NUMBER @"Preencha o campo Conta";
#define CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_PACKAGE @"Preencha o campo Embalagem";
#define CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_PACKAGE_CONDITION @"Preencha o campo Estado";
#define CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_REINBURSEMENT_TYPE @"Preencha o campo Tipo de restituição";
#define CONTACT_REQUEST_ALERT_DESCRIPTION_FORM @"O comentário deve ter no mínimo 10 caracteres"
#define CONTACT_REQUEST_SEND_REQUEST_SUCCESS @"Solicitação enviada com sucesso. Ticket número:"
#define CONTACT_REQUEST_SEND_REQUEST_ERROR @"Erro ao enviar solicitação"
#define CONTACT_REQUEST_BANK_SLIP_COPY @"Preciso da 2ª via de boleto"
#define CONTACT_REQUEST_BANK_SLIP_OUT_OF_DATE @"Pedido cancelado. O prazo do boleto venceu, não é mais possível efetuar o pagamento."
#define CONTACT_REQUEST_CREDIT_CARD_PAYMENT_REFUND_BANK_SLIP @"Seu pedido foi pago com cartão de crédito. Não é possível gerar 2ª via do boleto."
#define CONTACT_REQUEST_IMPROPER_BILLING @"Recebi cobrança indevida"
#define CONTACT_REQUEST_PAYMENT_NOT_CONFIRMED @"Meu pagamento não foi confirmado"
#define CONTACT_REQUEST_PAYMENT_WITHIN_LIMIT @"Seu pagamento ainda está dentro do prazo. Estamos aguardando confirmação do banco, avisaremos assim que o pagamento for confirmado ;)"
#define CONTACT_REQUEST_ORDER_NOT_FOUND @"Pedido não encontrado. Por favor tente novamente."
#define CONTACT_REQUEST_ORDER_WARRANTY_NOT_FOUND @"Este pedido não possui Garantia Estendida. Por favor selecione outro pedido."
#define CONTACT_REQUEST_ORDER_CANCELED @"Esse pedido está cancelado. Selecione outro pedido."

#define CONTACT_REQUEST_REOPEN_SEND_REQUEST_SUCCESS @"Solicitação reaberta com sucesso."
#define CONTACT_REQUEST_CLOSE_SEND_REQUEST_SUCCESS @"Solicitação cancelada com sucesso."

#define CONTACT_REQUEST_CREDIT_CARD_REFUND @"Seu pedido foi pago via cartão de crédito, caso sua solicitação seja aceita, devolveremos o seu dinheiro nas próximas faturas do seu cartão."
#define CONTACT_REQUEST_CREDIT_CARD_PAYMENT_VIA_CREDIT_CARD @"Seu pedido foi pago via cartão de crédito"

#define CONTACT_REQUEST_BANKING_SLIP_WITH_ACCOUNT_REFUND @"Seu pedido foi pago via boleto, caso sua solicitação seja aceita, devolveremos o seu dinheiro via transferência bancária. O CPF do titular da conta corrente deve ser o mesmo CPF do cliente que efetivou a compra no site do Walmart."
#define CONTACT_REQUEST_BANKING_SLIP_NO_ACCOUNT_REFUND @"Seu pedido foi pago via boleto, caso sua solicitação seja aceita, devolveremos o seu dinheiro através de uma ordem de pagamento."
#define CONTACT_REQUEST_PAYMENT_VIA_BANKING_SLIP_REFUND @"Seu pedido foi pago via boleto"
#define CONTACT_REQUEST_HAS_NO_BANK_ACCOUNT_REFUND @"Não tenho uma conta bancária."
#define CONTACT_REQUEST_HAS_BANK_ACCOUNT_REFUND @"Tenho uma conta bancária."

//Contact Ticket List
#define CONTACT_TICKET_LIST_TITLE @"Histórico de atendimento"
#define CONTACT_TICKET_LIST_REQUEST_ERROR @"Não foi possivel carregar seu histórico de atendimentos."

//Contact Ticket List Message Center
#define CONTACT_TICKET_LIST_MESSAGE_SEND_WARNING @"O comentário deve ter no mínimo 10 caracteres."
#define CONTACT_TICKET_LIST_MESSAGE_SEND_ERROR @"Falha ao enviar mensagem. Tente novamente."
#define CONTACT_TICKET_LIST_MESSAGE_UPLOAD_ERROR @"Falha ao enviar arquivo. Tente novamente."
#define CONTACT_TICKET_LIST_MESSAGE_UPLOAD_ERROR_FILE_SIZE @"O tamanho do arquivo não pode exceder 3MB."
#define CONTACT_TICKET_LIST_MESSAGE_DOWNLOAD_ERROR @"Falha ao fazer o download do arquivo. Tente novamente."

//Banking Slip (Boleto)
#define ERROR_BANKING_SLIP_CONNECTION @"Não foi possível gerar o boleto, por favor tente novamente ou entre em Minha conta > Pedidos > Selecione o pedido > Visualizar Boleto."
#define ERROR_BANKING_SLIP_NO_MAIL @"Para enviar este e-mail, você deve ter uma conta configurada no seu device."
#define ERROR_BANKING_SLIP_COMPOSER @"Houve um erro quando preparando o e-mail. Por favor, tente novamente."

//Banks
#define BANKS_ERROR_MESSAGE @"Não foi possível obter os bancos"

//Seller info
#define SELLER_SOLD_AND_DELIVERED_BY_FORMAT @"Vendido e entregue por %@"

//Wishlist
#define WISHLIST_ITEM_COUNT_FORMAT @"Você tem %ld %@ na sua lista ;)"
#define WISHLIST_PRODUCTS_ERROR @"Ops! Não foi possível carregar a sua lista de desejos."
#define WISHLIST_ADD_PRODUCT_ERROR @"Ops! Não foi possível adicionar em sua lista de desejos."
#define WISHLIST_REMOVE_PRODUCT_ERROR @"Ops! Não foi possível remover da sua lista de desejos."
#define WISHLIST_GENERIC_ERROR @"Ops! Não foi possível realizar essa requisição."
#define WISHLIST_SKU_ERROR_LIMIT @"Você atingiu o limite de sua lista de favoritos."
#define WISHLIST_EMPTY_VARIATIONS @"Antes de adicionar aos Favoritos, selecione a opção do produto."
#define WISHLIST_REQUEST_ERROR @"Não foi possível recuperar seus produtos favoritos."
#define WISHLIST_DISCOUNT_MESSAGE @"(custava %@ quando adicionado)"

#define WISHLIST_REQUEST_FEEDBACK_ERROR @"Houve um erro com sua requisção. Tente novamente"
#define WISHLIST_REMOVE_PRODUCT_CONFIRMATION @"Deseja remover o item da lista?"
#define WISHLIST_REMOVE_PRODUCTS_CONFIRMATION @"Deseja remover os itens da lista?"
#define WISHLIST_REMOVE_PRODUCT_SUCCESS @"Item removido da lista"
#define WISHLIST_REMOVE_PRODUCTS_SUCCESS @"Itens removidos da lista"
#define WISHLIST_ALREADY_BOUGHT_PRODUCT_SUCCESS @"Item movido para \"Já comprei\""
#define WISHLIST_ALREADY_BOUGHT_PRODUCTS_SUCCESS @"Itens movidos para \"Já comprei\""

#define VARIATION_POPUP_CONFIRM @"Confirmar"
#define VARIATION_POPUP_RETRY @"Tentar novamente"

#define TRACKING_NUMBER_TITLE @"Número de rastreio"

#define TOUCH_ID_REASON_MESSAGE @"Faça seu login usando o Touch ID"

//Pwd Strength
#define PWD_STRENGTH_NONE @"Força de senha"
#define PWD_STRENGTH_WEAK @"Fraca"
#define PWD_STRENGTH_MEDIUM @"Média"
#define PWD_STRENGTH_STRONG @"Forte"

//Search
#define SEARCH_BAR_PLACEHOLDER @"Olá, o que você procura?"

//Push Recover
#define RECOVER_PUSH_ALERT_TITLE @"Acompanhe seu pedido!"
#define RECOVER_PUSH_ALERT_MSG @"Autorize o envio de notificações para acompanhar o status do seu pedido e entrega em tempo real. Basta ir em 'Notificações' > 'Permitir Notificações'"

//Facebook Button titles
#define FACEBOOK_MSG_LOGOUT @"Logout Facebook"
#define FACEBOOK_MSG_LOGIN @"Conectar com Facebook"
#define FACEBOOK_MSG_LOGIN_SIMPLE @"Facebook"
#define FACEBOOK_MSG_LOGIN_CONNECTED @"Conectado"

//Facebook
#define FACEBOOK_MSG_ERROR_NO_TOKEN @"Não conseguimos uma autorização válida do Facebook. Por favor, tente novamente."
#define FACEBOOK_MSG_ERROR_UNKNOW @"Não foi possível entrar com sua conta Facebook. Por favor, tente novamente."

//Concierge Delivery
#define CONCIERGE_DELIVERY_ALERT_TITLE @"Atenção"
#define CONCIERGE_DELIVERY_ALERT_INFORMATIVE @"O prazo de entrega é válido para pagamentos identificados pelo Walmart.com até às 12h00 do dia da finalização da compra.\nCaso o pagamento não seja identificado até esse horário, acrescenta-se um dia útil ao prazo."
#define CONCIERGE_DELIVERY_ALERT_LATE @"Seu pagamento foi identificado por nossa equipe após às 12 horas.\nPor isso, como já informado, o seu pedido teve um dia útil acrescentado na entrega. Até lá."
#define CONCIERGE_DELIVERY_ALERT_DISMISS @"Fechar"

//Delivery
#define DELIVERY_SAME_DAY @"Entrega hoje"

//Coupon
#define COUPON_SUBMIT_SUCCESS @"Cupom de desconto incluído com sucesso"
#define COUPON_SUBMIT_FAILURE @"Cupom de desconto inválido"
#define COUPON_REMOVE_FAILURE @"Ops! Não foi possível excluir este cupom de desconto. Tente novamente"
#define COUPON_NOT_ALLOWED @"Cupom inválido."
#define COUPON_ALLOWED_ONLY_FOR_WALMART @"Cupom inválido."

//Review
#define REVIEW_EVALUATION_FAILURE @"Ops! Algo deu errado. Por favor tente novamente."

@interface OFMessages : NSObject

- (NSString *) getMsgCheckout:(NSString *) code;

//Button Try
- (NSString *) tryButton;

//Already
- (NSString *) emailAlready;
- (NSString *) cpfAlready;

//Greetings
- (NSString *) greeting_hi;
- (NSString *) greeting_ops;

//Place Order
- (NSString *) errorConnectionPO;
- (NSString *) errorPO;

//Installments
- (NSString *) errorConnectionInstallments;

//Payment
- (NSString *) noCreditCard;
- (NSString *) errorDocument;

- (NSString *) errorName;
- (NSString *) errorSecurity;
- (NSString *) errorMonth;
- (NSString *) errorYear;
- (NSString *) errorInstallments;
- (NSString *) errorValidateCard;

//Shippings
- (NSString *) errorConnectionShippings;
- (NSString *) errorShippings;
- (NSString *) errorDifferentValues;

//Shipment
- (NSString *) shipmentOptions;
- (NSString *) shipmentSchedule;
- (NSString *) shipmentDate;
- (NSString *) shipmentPeriod;


//Simulate
- (NSString *) errorShoppingCart;
- (NSString *) errorConnectionShopping;
- (NSString *) serverInferiorPrice;
- (NSString *) serverSuperiorPrice;
- (NSString *) qtyNotAvailable;
- (NSString *) productNotAvailable;

//Category errors
- (NSString *) errorConnectionCategory;
- (NSString *) errorUnknownCategory;

//Errors
- (NSString *) errorConnectionSplash;
- (NSString *) errorConnectionSkin;
- (NSString *) errorConnectionProduct;
- (NSString *) errorConnectionUnknown;
- (NSString *) errorConnectionInternet;
- (NSString *) errorConnectionInvalidData;
- (NSString *) errorParserShippingOptions;
- (NSString *) errorParseOrDatabase;
- (NSString *) errorConnectionImage;

//Qty availability
- (NSString *) errorProductStock;

//Zip
- (NSString *) errorZip;
- (NSString *) zipCodeInvalidError;

//Login
- (NSString *) errorLogin;
- (NSString *) privacyLoginMessage;
- (NSString *)loginUseTerms;
- (NSString *)loginPrivacyTerms;
- (NSString *) errorUnknownAuth;
- (NSString *) errorConnectionAuth;
- (NSString *)registerTermsMessage;
- (NSString *)registerTermsText;
- (NSString *)registerPrivacyText;

//Ship Address
- (NSString *) errorUnknownShipmentAddress;
- (NSString *) errorConnectionShipmentAddress;
- (NSString *) errorNoShipAdd;

//Success internet connection
- (NSString *) successConnectionInternet;

//Recover Password
- (NSString *) passOk;
- (NSString *) errorConnectionRecover;
- (NSString *) errorUnknownRecover;

//Basket
- (NSString *) emptyCart;

//Feedback
- (NSString *) helpMessage;
- (NSString *) errorSendFeedback;

//Address
- (NSString *) newAddressErrorMessage;
- (NSString *) updateAddressErrorMessage;
- (NSString *) zipCodeInfosErrorMessage;
- (NSString *) zipCodeInfosNotFoundMessage;
- (NSString *) zipCodeInvalidMessage;
- (NSString *) shipmentInfosErrorMessage;
- (NSString *) zipCodeChangedMessage;

//User
- (NSString *) updateUserErrorMessage;
- (NSString *) createUserErrorMessage;

//Invalids
- (NSString *) invalidBirthdayMessage;
- (NSString *) invalidMobileMessage;
- (NSString *) invalidTelephoneMessage;
- (NSString *) invalidCPFMessage;
- (NSString *) invalidCNPJMessage;
- (NSString *) invalidEmailMessage;
- (NSString *) invalidPasswordSixDigitsMessage;
- (NSString *) invalidNameMessage;
- (NSString *) emptyEmailMessage;
- (NSString *) emptyPassMessage;
- (NSString *) emptyEmailAndPassMessage;
- (NSString *) emptyCPFMessage;
- (NSString *) emptyPhoneMessage;
- (NSString *) emptyCompleteNomeMessage;
- (NSString *) emptyGeneralMessage;
- (NSString *) emptyLabelName;
- (NSString *) emptyLabelAddressType;
- (NSString *) emptyLabelStreet;
- (NSString *) emptyLabelNeighborhood;
- (NSString *) emptyLabelNumber;
- (NSString *) emptyLabelZipcode;
- (NSString *) emptyOrderWithTerm;
- (NSString *) emptyOrderWithoutTerm;
- (NSString *) emptyFilterWithTerm;
- (NSString *) emptyFilterWithoutTerm;

//Tracking
- (NSString *) errorOrders;
- (NSString *) errorMyAccount;
- (NSString *) emptyOrders;
- (NSString *) myAccountTitle;
- (NSString *) ordersTitle;
- (NSString *) errorOrderStatusDetail;
- (NSString *) expectedOrderDeliveryDate;
- (NSString *) seeInvoice;
- (NSString *) sendInvoice;
- (NSString *) installmentsRateMessage;

//Rating
- (NSString *) ratingMessageTitle;
- (NSString *) ratingMessageText;

//Home Footer
- (NSString *) errorHomeFooter;

//Filter
- (NSString *) errorFilterConnection;

//Extended Warranty
- (NSString *) extendedWarrantyProtocolMessage;
- (NSString *) extendedWarrantyLicenseErrorMessage;
- (NSString *) extendedWarrantySeparatePayment;

+ (NSString *)variationPopUpConfirmButton;
+ (NSString *)variationPopUpRetryButton;
+ (NSString *)trackingNumberTitle;
+ (NSString *)touchIdReasonMessage;

@end
