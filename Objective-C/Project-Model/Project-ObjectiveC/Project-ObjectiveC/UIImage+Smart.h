//
//  UIImage+Smart.h
//  Project-ObjectiveC
//
//  Created by Erico Teixeira - Terceiro on 24/04/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Smart)

#pragma mark - Commum

/** Converte um texto base64 para a imagem correspondente.*/
+ (UIImage * _Nullable) decodeBase64StringToImage:(NSString * _Nonnull)base64string;

/** Converte uma imagem para sua representação base64 string. */
- (NSString * _Nullable) encodeImageToBase64String;

/**
 * Copia a imagem, incluindo a animação, se existir.
 *
 * @return Retorna uma nova instância cópia do objeto imagem original.
 */
- (UIImage * _Nonnull)clone;

#pragma mark - Animation

/**
 * Este método cria um 'UIImage' animado usando como fonte uma imagem GIF.
 *
 * O arquivo GIF armazena em separado a duração para cada frame, na unidade centézimos de segundo. Entretando, a classe 'UIImage' somente possui uma propriedade 'duration' para guardar o tempo, do tipo ponto-flutuante (double).
 *
 * Para lidar com esta incompatibilidade, cada frame da imagem de origem (do GIF) é adicionada à `animação` um número variável de vezes para corresponder às proporções entre as durações dos quadros no GIF.
 *
 * Por exemplo, suponha que o GIF contenha três quadros. O quadro 0 tem duração 3. O quadro 1 tem duração 9. O quadro 2 tem duração 15. Divide-se cada duração pelo maior denominador comum de todas as durações, que é 3, e adiciona-se cada quadro ao número resultante de vezes. Assim, 'animation' conterá o quadro 0 3/3 = 1 vez, depois o quadro 1 9/3 = 3 vezes, depois o quadro 2 15/3 = 5 vezes. Assim é definido 'animation.duration' para (3 + 9 + 15) / 100 = 0,27 segundos.
 *
 * @brief Instancia uma imagem animada de um arquivo tipo GIF.
 * @warning É necessário que o arquivo carregado seja do tipo GIF para que a animação seja processada corretamente.
 * @param theData Objeto NSData do arquivo de imagem.
 * @return Retorna Uma nova imagem animada.
 * @note Utilize este método para carregar os frames de um arquivo GIF numa animação da UIImage.
 */
+ (UIImage * _Nullable)animatedImageWithAnimatedGIFData:(NSData * _Nonnull)theData;

/**
 * Este método opera extamente como \c <animatedImageWithAnimatedGIFData:>, exceto pelo fato que os dados são recuperados de uma URL.
 *
 * @brief Instancia uma imagem animada de um arquivo tipo GIF, referenciado pela URL do arquivo.
 * @warning É necessário que o arquivo carregado seja do tipo GIF para que a animação seja processada corretamente.
 * @param theURL URL do arquivo. Se \c theURL não for um arquivo local é aconselhável que a chamada seja feita em background para evitar o bloqueio da thread principal.
 * @return Retorna Uma nova imagem animada.
 * @note Utilize este método para carregar os frames de um arquivo GIF numa animação da UIImage.
 */
+ (UIImage * _Nullable)animatedImageWithAnimatedGIFURL:(NSURL * _Nonnull)theURL;

/**
 * Este método permite que cada frame da animação seja exibido por uma duração arbitrária.
 *
 * Observe que a duração total da animação será dada pela soma de todos os tempos passados no parâmetro \c durations.
 *
 * @brief Instancia uma imagem animada utilizando uma lista de imagens (frames) e tempos (timeFrames).
 * @warning É necessário que as imagens da lista parâmetro possuam a mesma dimensão e escala. Além disso, cada imagem precisa ter a propriedade 'CGImage' não nula e o número de imagens e tempos sejam equivalentes.
 * @param images Cada imagem desta lista será um ou vários frames da animação final.
 * @param durations Cada duração desta lista representa a parcela de tempo que uma imagem deve ficar visível na animação.
 * @return Retorna um objeto UIImage animado.
 * @note Este método é uma alternativa ao método \c <animatedImageNamed:duration:> em que cada frame (imagem individual da animação) pode ficar visível uma parcela de tempo variável.
 */
+ (UIImage * _Nullable)animatedImageWithImages:(NSArray<UIImage *> * _Nonnull)images durations:(NSArray<NSNumber *> * _Nonnull)durations;

/**
 * Verifica se a imagem instanciada é uma animação.
 *
 * @return O retorno será YES para imagens animadas e NO para imagens normais.
 */
- (BOOL)isAnimated;

#pragma mark - Transforms

/**
 * É necessário que a imagem origem possua a propriedade 'CGImage' não nula e nenhuma de suas dimensões (largura ou altura) pode ser zero (0).
 *
 * @brief Cria uma nova imagem com orientação modificada (UIImageOrientationUp).
 * @warning Não é executado em imagens animadas.
 * @return Retorna uma cópia alterada da imagem origem. Caso o método não consiga executar a transformação, será retornada a própria imagem original.
 * @note Utilize o método \p <imageRotatedByDegrees:> para ângulos arbitrários.
 */
- (UIImage * _Nullable)imageOrientedToUP;

/**
 * É necessário que a imagem origem possua a propriedade 'CGImage' não nula e nenhuma de suas dimensões (largura ou altura) pode ser zero (0).
 *
 * @brief Cria uma nova imagem rotacionada no sentido horário.
 * @warning Não é executado em imagens animadas.
 * @return Retorna uma cópia alterada da imagem origem. Caso o método não consiga executar a transformação, será retornada a própria imagem original.
 * @note Utilize o método \p <imageRotatedByDegrees:> para ângulos arbitrários.
 */
- (UIImage * _Nullable)imageRotatedClockwise;

/**
 * É necessário que a imagem origem possua a propriedade 'CGImage' não nula e nenhuma de suas dimensões (largura ou altura) pode ser zero (0).
 *
 * @brief Cria uma nova imagem rotacionada no sentido antihorário.
 * @warning Não é executado em imagens animadas.
 * @return Retorna uma cópia alterada da imagem origem. Caso o método não consiga executar a transformação, será retornada a própria imagem original.
 * @note Utilize o método \p <imageRotatedByDegrees:> para ângulos arbitrários.
 */
- (UIImage * _Nullable)imageRotatedCounterClockwise;

/**
 * É necessário que a imagem origem possua a propriedade 'CGImage' não nula e nenhuma de suas dimensões (largura ou altura) pode ser zero (0).
 *
 * @brief Cria uma nova imagem rotacionada num ângulo arbitrário.
 * @warning Não é executado em imagens animadas.
 * @param degrees Ângulo, em graus, que se deseja girar a imagem. Pode ser negativo.
 * @return Retorna uma cópia alterada da imagem origem. Caso o método não consiga executar a transformação, será retornada a própria imagem original.
 */
- (UIImage * _Nullable)imageRotatedByDegrees:(CGFloat)degrees;

/**
 * É necessário que a imagem origem possua a propriedade 'CGImage' não nula e nenhuma de suas dimensões (largura ou altura) pode ser zero (0).
 *
 * @brief Cria uma nova imagem horizontalmente espelhada.
 * @warning Não é executado em imagens animadas.
 * @return Retorna uma cópia alterada da imagem origem. Caso o método não consiga executar a transformação, será retornada a própria imagem original.
 */
- (UIImage * _Nullable)imageFlippedHorizontally;

/**
 * É necessário que a imagem origem possua a propriedade 'CGImage' não nula e nenhuma de suas dimensões (largura ou altura) pode ser zero (0).
 *
 * @brief Cria uma nova imagem verticalmente espelhada.
 * @warning Não é executado em imagens animadas.
 * @return Retorna uma cópia alterada da imagem origem. Caso o método não consiga executar a transformação, será retornada a própria imagem original.
 */
- (UIImage * _Nullable)imageFlippedVertically;

/** Faz uma cópia da imagem, num novo tamanho. */
- (UIImage * _Nullable) resizedImageToSize:(CGSize)newSize;

/** Copia a imagem original, modificando o tamanho conforme a escala parâmetro. */
- (UIImage * _Nullable) resizedImageToScale:(CGFloat)newScale;

/** Cria uma nova imagem baseado na imagem original, mantendo o aspecto original. O parâmetro 'frameSize' deve ser dado em points, conforme tamanho do componente (ex.: UIImageView.frame.size). Utilize 'bounds' do componente para transformações, quando necessário. */
- (UIImage * _Nullable) resizedImageToViewFrame:(CGSize)frameSize;

/** Este método retorna uma nova imagem, baseando-se numa dada área da imagem original. */
- (UIImage * _Nullable) cropImageUsingFrame:(CGRect)frame;

/** Cria uma nova imagem, baseando-se numa dada área circular da imagem original. */
//- (UIImage * _Nullable) circularCropImageUsingFrame:(CGRect)frame;

#pragma mark - Effects

/** Aplica filtro na imagem parâmetro. Certos filtros exigem parâmetros adicionais que devem ser passados pelo dicionário. Visitar o endereço para ver as opções: https://developer.apple.com/library/content/documentation/GraphicsImaging/Reference/CoreImageFilterReference/#//apple_ref/doc/uid/TP30000136-SW29. */
- (UIImage * _Nullable) applyFilter:(NSString * _Nonnull)filterName usingParameters:(NSDictionary * _Nullable)parameters;

/** Comprime uma imagem para reduzir sua qualidade (e consequentemente tamanho). O parâmetro 'image' é transformado no formato JPEG para qualidades inferiores a 1.0 (neste caso haverá perda de transparência). */
- (UIImage * _Nullable) compressImageUsingQuality:(CGFloat)quality;

/** Mescla duas imagens, colocando a imagem parâmetro por cima. É possível definir posição, mistura, transparência e escala para a imagem superior (top).*/
- (UIImage * _Nullable) mergeImageAbove:(UIImage * _Nonnull)aboveImage inPosition:(CGPoint)position blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha scale:(CGFloat)superImageScale;

/** Mescla duas imagens, colocando a imagem parâmetro por baixo. É possível definir posição, mistura, transparência e escala para a imagem inferior (bottom).*/
- (UIImage * _Nullable) mergeImageBelow:(UIImage * _Nonnull)belowImage inPosition:(CGPoint)position blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha scale:(CGFloat)superImageScale;

/** Aplica uma máscara na imagem base, gerando uma nova imagem 'vazada'. A máscara deve ser uma imagem sem alpha, em escala de cinza (o branco define a transparência, preto solidez). */
//- (UIImage * _Nullable) maskWithImage:(UIImage * _Nonnull)maskImage;

- (UIImage * _Nullable) applyBorderWithColor:(UIColor * _Nonnull)borderColor blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha andWidth:(CGFloat)borderWidth;

- (UIImage * _Nullable) tintImageWithColor:(UIColor * _Nonnull)color;

- (UIImage * _Nullable) bluredImageWithRadius:(CGFloat)radius;

@end

