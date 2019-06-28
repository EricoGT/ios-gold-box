//
//  UIImage+Extensions.swift
//  ProjectModel
//
//  Created by Erico Gimenes Teixeira on 25/06/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

import UIKit
import ImageIO
import Accelerate

extension UIImage {
    
    //******************************************************************************************************
    //MARK: - Commum
    //******************************************************************************************************
    
    /** Converte um texto base64 para a imagem correspondente.*/
    class func decodeToImage(base64String:String) -> UIImage? {
        if (App.Utils.Validation.textCheckRelevantContent(text: base64String)) {
            if let data:Data = Data.init(base64Encoded: base64String, options: .ignoreUnknownCharacters) {
                return UIImage.init(data: data)
            }
        }
        return nil
    }
    
    /** Converte uma imagem para sua representação base64 string. */
    func encodeToBase64String() -> String? {
        if (self.isAnimated()){
            return nil
        }
        //
        if let data:Data = self.pngData() {
            return data.base64EncodedString(options: .endLineWithLineFeed)
        }
        return nil
    }
    
    /**
     * Copia a imagem, incluindo a animação, se existir.
     * @return Retorna uma nova instância cópia do objeto imagem original.
     */
    func clone() -> UIImage {
        
        if ((self.images?.count ?? 0) > 1) {
            //copiando animações
            
            if let data = self.pngData() {
                return UIImage.init(data: data)!
            }
            
            //TODO; após ter animaçÕes:
            //UIImage *animationImage = [UIImage animatedImageWithImages:self.images duration:self.duration];
            //return animationImage;
            
        }
        
        //copiando imagem única
        if let data = self.pngData() {
            return UIImage.init(data: data)!
        }
        
        return self
    }
    
    //******************************************************************************************************
    //MARK: - Animation
    //******************************************************************************************************
    
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
     * @param data Objeto NSData do arquivo de imagem.
     * @return Retorna Uma nova imagem animada.
     * @note Utilize este método para carregar os frames de um arquivo GIF numa animação da UIImage.
     */
    class func animatedImageWithAnimatedGIF(data:Data) -> UIImage? {
        if let imageSource:CGImageSource = CGImageSourceCreateWithData(data as CFData, nil) {
            return animatedImageWithAnimatedGIFImageSource(source: imageSource)
        }
        //
        return nil
    }
    
    /**
     * Este método opera extamente como \c <animatedImageWithAnimatedGIFData:>, exceto pelo fato que os dados são recuperados de uma URL.
     *
     * @brief Instancia uma imagem animada de um arquivo tipo GIF, referenciado pela URL do arquivo.
     * @warning É necessário que o arquivo carregado seja do tipo GIF para que a animação seja processada corretamente.
     * @param theURL URL do arquivo. Se \c theURL não for um arquivo local é aconselhável que a chamada seja feita em background para evitar o bloqueio da thread principal.
     * @return Retorna Uma nova imagem animada.
     * @note Utilize este método para carregar os frames de um arquivo GIF numa animação da UIImage.
     */
    class func animatedImageWithAnimatedGIF(url:URL) -> UIImage? {
        if let imageSource:CGImageSource = CGImageSourceCreateWithURL(url as CFURL, nil) {
            return animatedImageWithAnimatedGIFImageSource(source: imageSource)
        }
        //
        return nil
    }
    
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
    class func animatedImageWithFrames(images:[UIImage], durations:[Int]) -> UIImage? {
        
        if images.count == 0 || durations.count == 0 {
            return nil
        }
        
        if images.count != durations.count {
            return nil
        }
        
        let totalDurationCentiseconds = sum(values: durations)
        
        let gcd:Int = vectorGCD(count: images.count, values: durations)
        var _:Int = totalDurationCentiseconds / gcd
        var frames:[UIImage] = Array()
        //
        for i in 0 ..< images.count {
            let frame:UIImage = images[i]
            let start:Int = durations[i] / gcd
            let end:Int = 0
            for _ in stride(from: start, to: end, by: -1) {
                frames.append(frame)
            }
        }
        //
        return  UIImage.animatedImage(with: frames, duration: TimeInterval.init(Float.init(totalDurationCentiseconds) / 100.0))
    }
    
    /**
     * Verifica se a imagem instanciada é uma animação.
     * @return O retorno será 'true' para imagens animadas e 'false' para imagens normais.
     */
    func isAnimated() -> Bool {
        if ((self.images?.count ?? 0) > 1) {
            return true
        }
        return false
    }
    
    //******************************************************************************************************
    //MARK: - TRANSFORMS
    //******************************************************************************************************
    
    /**
     * É necessário que a imagem origem possua a propriedade 'CGImage' não nula e nenhuma de suas dimensões (largura ou altura) pode ser zero (0).
     *
     * @brief Cria uma nova imagem com orientação modificada (UIImageOrientationUp).
     * @warning Não é executado em imagens animadas.
     * @return Retorna uma cópia alterada da imagem origem. Caso o método não consiga executar a transformação, será retornada a própria imagem original.
     * @note Utilize o método \p <imageRotatedByDegrees:> para ângulos arbitrários.
     */
    func imageOrientedToUP() -> UIImage {
        
        if self.imageOrientation == .up || self.cgImage == nil || self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            return self
        }
        
        var transform:CGAffineTransform = CGAffineTransform.identity
        
        //
        
        switch self.imageOrientation {
 
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Float.pi))
            break
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Float.pi / 2.0))
            break
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -CGFloat(Float.pi / 2.0))
            break
            
        default:
            break
        }
        
        //
        
        switch self.imageOrientation {
            
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: -1)
            break
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: -1)
            break
            
        default:
            break
        }
        
        if let context = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: (self.cgImage!).bitsPerComponent, bytesPerRow: (self.cgImage!).bytesPerRow,  space: (self.cgImage!).colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
            
            context.concatenate(transform);
            
            switch self.imageOrientation {
                
            case .left, .leftMirrored, .right, .rightMirrored:
                context.draw(self.cgImage!, in: CGRect.init(x: 0.0, y: 0.0, width: self.size.height, height: self.size.width))
                break
                
            default:
                context.draw(self.cgImage!, in: CGRect.init(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height))
                break
            }
            
            if let cgImage:CGImage = context.makeImage() {
                let finalImage:UIImage = UIImage.init(cgImage: cgImage)
                //
                return finalImage
            } else {
                return self
            }
            
        } else {
            return self
        }
    }
    
    /**
     * É necessário que a imagem origem possua a propriedade 'CGImage' não nula e nenhuma de suas dimensões (largura ou altura) pode ser zero (0).
     *
     * @brief Cria uma nova imagem rotacionada no sentido horário.
     * @warning Não é executado em imagens animadas.
     * @return Retorna uma cópia alterada da imagem origem. Caso o método não consiga executar a transformação, será retornada a própria imagem original.
     * @note Utilize o método \p <imageRotatedByDegrees:> para ângulos arbitrários.
     */
    func imageRotatedClockwise() -> UIImage {
        return imageRotated(byDegrees: 90.0)
    }
    
    /**
     * É necessário que a imagem origem possua a propriedade 'CGImage' não nula e nenhuma de suas dimensões (largura ou altura) pode ser zero (0).
     *
     * @brief Cria uma nova imagem rotacionada no sentido antihorário.
     * @warning Não é executado em imagens animadas.
     * @return Retorna uma cópia alterada da imagem origem. Caso o método não consiga executar a transformação, será retornada a própria imagem original.
     * @note Utilize o método \p <imageRotatedByDegrees:> para ângulos arbitrários.
     */
    func imageRotatedCounterClockwise() -> UIImage {
        return imageRotated(byDegrees: -90.0)
    }
    
    /**
     * É necessário que a imagem origem possua a propriedade 'CGImage' não nula e nenhuma de suas dimensões (largura ou altura) pode ser zero (0).
     *
     * @brief Cria uma nova imagem rotacionada num ângulo arbitrário.
     * @warning Não é executado em imagens animadas.
     * @param byDegrees Ângulo, em graus, que se deseja girar a imagem. Pode ser negativo.
     * @return Retorna uma cópia alterada da imagem origem. Caso o método não consiga executar a transformação, será retornada a própria imagem original.
     */
    func imageRotated(byDegrees:CGFloat) -> UIImage {
        
        if self.cgImage == nil || self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            return self
        }
        
        let rotation = self.radians(fromDegrees: byDegrees)
        
        // Calculate Destination Size
        let transform:CGAffineTransform = CGAffineTransform.init(rotationAngle: rotation)
        let sizeRect:CGRect = CGRect.init(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        let destRect:CGRect = sizeRect.applying(transform)
        let destinationSize:CGSize = destRect.size
        
        // Draw image
        UIGraphicsBeginImageContext(destinationSize)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: destinationSize.width / 2.0, y: destinationSize.height / 2.0)
        context?.rotate(by: rotation)
        self.draw(in: CGRect.init(x: -self.size.width / 2.0, y: -self.size.height / 2.0, width: self.size.width, height: self.size.height))
        
        // Save image
        let newImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return newImage ?? self;
    }
    
    /**
     * É necessário que a imagem origem possua a propriedade 'CGImage' não nula e nenhuma de suas dimensões (largura ou altura) pode ser zero (0).
     *
     * @brief Cria uma nova imagem horizontalmente espelhada.
     * @warning Não é executado em imagens animadas.
     * @return Retorna uma cópia alterada da imagem origem. Caso o método não consiga executar a transformação, será retornada a própria imagem original.
     */
    func imageFlippedHorizontally() -> UIImage {
        
        if self.cgImage == nil || self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            return self
        }
        
        let transform:CGAffineTransform = CGAffineTransform.init(scaleX: -1, y: 1)
        var ciImage:CIImage = CIImage.init(image: self)!
        ciImage = ciImage.transformed(by: transform)
        
        let context:CIContext = CIContext.init()
        let cgimg:CGImage = context.createCGImage(ciImage, from: ciImage.extent)!
        
        let flippedImage = UIImage.init(cgImage: cgimg)
        
        return flippedImage;
    }
    
    /**
     * É necessário que a imagem origem possua a propriedade 'CGImage' não nula e nenhuma de suas dimensões (largura ou altura) pode ser zero (0).
     *
     * @brief Cria uma nova imagem verticalmente espelhada.
     * @warning Não é executado em imagens animadas.
     * @return Retorna uma cópia alterada da imagem origem. Caso o método não consiga executar a transformação, será retornada a própria imagem original.
     */
    func imageFlippedVertically() -> UIImage {
        
        if self.cgImage == nil || self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            return self
        }
        
        let transform:CGAffineTransform = CGAffineTransform.init(scaleX: 1, y: -1)
        var ciImage:CIImage = CIImage.init(image: self)!
        ciImage = ciImage.transformed(by: transform)
        
        let context:CIContext = CIContext.init()
        let cgimg:CGImage = context.createCGImage(ciImage, from: ciImage.extent)!
        
        let flippedImage = UIImage.init(cgImage: cgimg)
        
        return flippedImage;
    }
    
    /** Faz uma cópia da imagem, num novo tamanho. */
    func resizedImageToSize(_ newSize:CGSize) -> UIImage {
        
        if self.isAnimated() {
            //Imagem animada
            var iList:[UIImage] = Array()
            for image in self.images! {
                UIGraphicsBeginImageContext(newSize)
                image.draw(in: CGRect.init(x: 0.0, y: 0.0, width: newSize.width, height: newSize.height))
                if let frame:UIImage = UIGraphicsGetImageFromCurrentImageContext() {
                    iList.append(frame)
                }
                UIGraphicsEndImageContext();
            }
            let newImage:UIImage? = UIImage.animatedImage(with: iList, duration: self.duration)
            return newImage ?? self
        } else {
            //Imagem estática
            UIGraphicsBeginImageContext(newSize)
            self.draw(in: CGRect.init(x: 0.0, y: 0.0, width: newSize.width, height: newSize.height))
            let newImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext();
            return newImage ?? self
        }
    }
    
    /** Copia a imagem original, modificando o tamanho conforme a escala parâmetro. */
    func resizedImageToScale(_ newScale:CGFloat) -> UIImage {
        let newSize = CGSize.init(width: self.size.width * newScale, height: self.size.height * newScale)
        return self.resizedImageToSize(newSize)
    }
    
    
    /** Cria uma nova imagem baseado na imagem original, mantendo o aspecto original. O parâmetro 'frameSize' deve ser dado em points, conforme tamanho do componente (ex.: UIImageView.frame.size). Utilize 'bounds' do componente para transformações, quando necessário. */
    func resizedImageToFrameSize(_ frameSize:CGSize) -> UIImage {
        
        var width = self.size.width
        var height = self.size.height
        let ratio = width / height
        let scale = UIScreen.main.nativeScale
        let maxWidth = frameSize.width * scale
        let maxHeight = frameSize.height * scale
        //
        if width > maxWidth {
            width = maxWidth
            height = width / ratio
        } else if height > maxHeight {
            height = maxHeight
            width = height * ratio
        }
        //
        let newSize = CGSize.init(width: width, height: height)
        return self.resizedImageToSize(newSize)
    }
    
    /** Este método retorna uma nova imagem, baseando-se numa dada área da imagem original. */
    func cropImageUsingFrame(_ frame:CGRect) -> UIImage {
        
        if self.cgImage == nil || self.size.width == 0 || self.size.height == 0 {
            return self
        }
        
        if self.isAnimated() {
            //Imagem animada
            var iList:[UIImage] = Array()
            for image in self.images! {
                if let imageRef:CGImage = image.cgImage!.cropping(to: frame) {
                    let outImage:UIImage = UIImage.init(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
                    iList.append(outImage)
                }
            }
            let newImage:UIImage? = UIImage.animatedImage(with: iList, duration: self.duration)
            return newImage ?? self
        } else {
            //Imagem estática
            if let imageRef:CGImage = self.cgImage!.cropping(to: frame) {
                let outImage:UIImage = UIImage.init(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
                return outImage
            }
        }
        return self
    }
    
    /** Cria uma nova imagem, baseando-se numa dada área circular da imagem original. */
    func circularCropImageUsingFrame(_ frame:CGRect) -> UIImage {
        
        let cropedImage:UIImage = self.cropImageUsingFrame(frame)
        
        if cropedImage == self {
            return self
        }
        
        if self.isAnimated() {
            //Imagem animada
            var iList:[UIImage] = Array()
            for image in self.images! {
                iList.append(self.circularCrop(image: image))
            }
            let newImage:UIImage? = UIImage.animatedImage(with: iList, duration: self.duration)
            return newImage ?? self
        } else {
            //Imagem estática
            return self.circularCrop(image: cropedImage)
        }
    }
    
    /** Cria uma nova imagem, com bordas arredondadas conforme parâmetro. */
    func roundedCornerImage(radius:CGFloat, corners:UIRectCorner) -> UIImage {
        
        if self.cgImage == nil || self.size.width == 0 || self.size.height == 0 || radius <= 1.0 {
            return self
        }
        
        if self.isAnimated() {
            //Imagem animada
            var iList:[UIImage] = Array()
            for image in self.images! {
                iList.append(self.roundedRect(image: image, radius: radius, corners: corners))
            }
            let newImage:UIImage? = UIImage.animatedImage(with: iList, duration: self.duration)
            return newImage ?? self
        } else {
            //Imagem estática
            return self.roundedRect(image: self, radius: radius, corners: corners)
        }
    }
    
    /** Utiliza um CGPath para cortar a imagem. */
    func imageByClipping(path:CGPath) -> UIImage {
        
        if self.cgImage == nil || self.size.width == 0 || self.size.height == 0 {
            return self
        }
        
        if self.isAnimated() {
            //Imagem animada
            var iList:[UIImage] = Array()
            for image in self.images! {
                iList.append(self.clipping(image: image, path: path))
            }
            let newImage:UIImage? = UIImage.animatedImage(with: iList, duration: self.duration)
            return newImage ?? self
        } else {
            //Imagem estática
            return self.clipping(image: self, path: path)
        }
    }
    
    
    
    //******************************************************************************************************
    //MARK: - EFFECTS
    //******************************************************************************************************
    
    /** Aplica filtro na imagem parâmetro. Certos filtros exigem parâmetros adicionais que devem ser passados pelo dicionário. Visitar o endereço para ver as opções: https://developer.apple.com/library/content/documentation/GraphicsImaging/Reference/CoreImageFilterReference/#//apple_ref/doc/uid/TP30000136-SW29. */
    func applyFilter(name:String, parameters:Dictionary<String,Any>?) -> UIImage {
        
        if self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            return self
        }
        
        let ciImage:CIImage = CIImage.init(image: self)!
        let context:CIContext = CIContext.init()
        //
        if let ciFilter:CIFilter = CIFilter.init(name: name) {
            //In case no parameter is passed, the input image will already be in the filter by default:
            ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
            if let param = parameters {
                ciFilter.setValuesForKeys(param)
            }
            //
            if let outputImage:CIImage = ciFilter.outputImage {
                let cgimg:CGImage = context.createCGImage(outputImage, from: outputImage.extent)!
                let newImage:UIImage = UIImage.init(cgImage: cgimg, scale: self.scale, orientation: self.imageOrientation)
                return newImage
            }
        }
        //
        return self
    }
    
    /** Comprime uma imagem para reduzir sua qualidade (e consequentemente tamanho). O parâmetro 'image' é transformado no formato JPEG para qualidades inferiores a 1.0 (neste caso haverá perda de transparência). */
    func compressImage(quality:CGFloat) -> UIImage {
        
        let q = quality < 0.0 ? 0.0 : (quality > 1.0 ? 1.0 : quality)
        
        if self.isAnimated() {
            //Imagem animada
            var iList:[UIImage] = Array()
            for image in self.images! {
                iList.append(self.compress(image: image, quality: q))
            }
            let newImage:UIImage? = UIImage.animatedImage(with: iList, duration: self.duration)
            return newImage ?? self
        } else {
            //Imagem estática
            return self.compress(image: self, quality: q)
        }
    }
    
    /** Mescla duas imagens, colocando a imagem parâmetro por cima. É possível definir posição, mistura, transparência e escala para a imagem superior (top).*/
    func mergeImageAbove(anotherImage:UIImage, position:CGPoint, blendMode:CGBlendMode, alpha:CGFloat, scale:CGFloat) -> UIImage {
        
        if self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            return self
        }
        
        let widthB = self.size.width
        let heightB = self.size.height
        let baseSize = CGSize.init(width: widthB, height: heightB)
        
        let widthS = anotherImage.size.width * scale
        let heightS = anotherImage.size.height * scale
        let superSize = CGSize.init(width: widthS, height: heightS)
        
        UIGraphicsBeginImageContext(baseSize)
        
        //Desenhando a imagem base:
        self.draw(in: CGRect.init(x: 0.0, y: 0.0, width: baseSize.width, height: baseSize.height))
        
        //Desenhando a imagem superior:
        anotherImage.draw(in: CGRect.init(x: position.x, y: position.y, width: superSize.width, height: superSize.height), blendMode: blendMode, alpha: alpha)
        
        //Obtendo a imagem final:
        let newImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage ?? self;
    }
    
    /** Mescla duas imagens, colocando a imagem parâmetro por baixo. É possível definir posição, mistura, transparência e escala para a imagem inferior (bottom).*/
    func mergeImageBelow(anotherImage:UIImage, position:CGPoint, blendMode:CGBlendMode, alpha:CGFloat, scale:CGFloat) -> UIImage {
        
        if self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            return self
        }
        
        let widthB = anotherImage.size.width
        let heightB = anotherImage.size.height
        let baseSize = CGSize.init(width: widthB, height: heightB)
        
        let widthS = self.size.width * scale
        let heightS = self.size.height * scale
        let superSize = CGSize.init(width: widthS, height: heightS)
        
        UIGraphicsBeginImageContext(baseSize)
        
        //Desenhando a imagem base:
        anotherImage.draw(in: CGRect.init(x: 0.0, y: 0.0, width: baseSize.width, height: baseSize.height))
        
        //Desenhando a imagem superior:
        self.draw(in: CGRect.init(x: position.x, y: position.y, width: superSize.width, height: superSize.height), blendMode: blendMode, alpha: alpha)
        
        //Obtendo a imagem final:
        let newImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage ?? self;
    }
    
    /** Aplica uma máscara na imagem base, gerando uma nova imagem 'vazada'. A máscara deve ser uma imagem sem alpha, em escala de cinza (o branco define a transparência, preto solidez). */
    func maskWithGrayscaleImage(maskImage:UIImage) -> UIImage {
        
        if self.cgImage == nil || maskImage.cgImage == nil || self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            return self
        }
        
        let filterName = "CIBlendWithMask"
        
        let inputImage = CIImage.init(cgImage: self.cgImage!)
        let inputMaskImage = CIImage.init(cgImage: maskImage.cgImage!)
        
        let context:CIContext = CIContext.init()
        
        if let ciFilter:CIFilter = CIFilter.init(name: filterName) {
            ciFilter.setValue(inputImage, forKey: kCIInputImageKey)
            ciFilter.setValue(inputMaskImage, forKey: kCIInputMaskImageKey)
            //
            if let outputImage:CIImage = ciFilter.outputImage {
                let cgimg:CGImage = context.createCGImage(outputImage, from: outputImage.extent)!
                let newImage:UIImage = UIImage.init(cgImage: cgimg, scale: self.scale, orientation: self.imageOrientation)
                return newImage
            }
        }
        
        return self
    }
    
    /** Aplica uma máscara na imagem base, gerando uma nova imagem 'vazada'. A máscara deve conter canal alpha, que definirá a visibilidade final da imagem resultante. */
    func maskWithAlphaImage(maskImage:UIImage) -> UIImage {
        
        if self.cgImage == nil || maskImage.cgImage == nil || self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            return self
        }
        
        let filterName = "CIBlendWithAlphaMask"
        
        let inputImage = CIImage.init(cgImage: self.cgImage!)
        let inputMaskImage = CIImage.init(cgImage: maskImage.cgImage!)
        
        let context:CIContext = CIContext.init()
        
        if let ciFilter:CIFilter = CIFilter.init(name: filterName) {
            ciFilter.setValue(inputImage, forKey: kCIInputImageKey)
            ciFilter.setValue(inputMaskImage, forKey: kCIInputMaskImageKey)
            //
            if let outputImage:CIImage = ciFilter.outputImage {
                let cgimg:CGImage = context.createCGImage(outputImage, from: outputImage.extent)!
                let newImage:UIImage = UIImage.init(cgImage: cgimg, scale: self.scale, orientation: self.imageOrientation)
                return newImage
            }
        }
        
        return self
    }
    
    /** Cria uma nova imagem aplicando uma borda com os parâmetros. */
    func applyBorder(color:UIColor, width:CGFloat) -> UIImage {
        
        if self.cgImage == nil || self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            return self
        }
        
        UIGraphicsBeginImageContext(self.size);
        let rect:CGRect = CGRect.init(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        self.draw(in: rect, blendMode: .normal, alpha: 1.0) //changes in alpha can be set in color directly
        //
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(color.cgColor)
        context?.setLineWidth(width)
        context?.stroke(rect)
        //
        let newImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //
        return newImage ?? self
    }
    
    /** Cria uma cópia de uma imagem fazendo sobreposição de cor.*/
    func tintImage(color:UIColor) -> UIImage {
        
        let newImage = self.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        color.set()
        newImage.draw(in: CGRect.init(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height))
        let finalImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //
        return finalImage ?? self
    }
    
    /** Adiciona o efeito GaussianBlur em uma nova instância da imagem, atuando apenas nas regiões definidas pela máscara (0 para preto e 'radius' para branco). */
    func bluredImage(radius:CGFloat, grayMaskImage:UIImage) -> UIImage {
        
        if self.cgImage == nil || self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            return self
        }
        
        let filterName = "CIMaskedVariableBlur"
        
        let inputImage = CIImage.init(cgImage: self.cgImage!)
        
        let context:CIContext = CIContext.init()
        
        if let ciFilter:CIFilter = CIFilter.init(name: filterName) {
            ciFilter.setValue(inputImage, forKey: kCIInputImageKey)
            ciFilter.setValue(radius, forKey: kCIInputRadiusKey)
            //
            if let cgInputMaskImage = grayMaskImage.cgImage {
                let inputMaskImage = CIImage.init(cgImage: cgInputMaskImage)
                ciFilter.setValue(inputMaskImage, forKey: "inputMask") //NOTE: 'kCIInputMaskImageKey' is not key value coding-compliant...
            }
            //
            if let outputImage:CIImage = ciFilter.outputImage {
                let cgimg:CGImage = context.createCGImage(outputImage, from: outputImage.extent)!
                let newImage:UIImage = UIImage.init(cgImage: cgimg, scale: self.scale, orientation: self.imageOrientation)
                return newImage
            }
        }
        
        return self
    }
    
    func bluredImage(radius:CGFloat) -> UIImage {
        
        if self.cgImage == nil || self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            return self
        }
        
        let filterName = "CIGaussianBlur"
        
        let inputImage = CIImage.init(cgImage: self.cgImage!)
        
        let context:CIContext = CIContext.init()
        
        if let ciFilter:CIFilter = CIFilter.init(name: filterName) {
            ciFilter.setValue(inputImage, forKey: kCIInputImageKey)
            ciFilter.setValue(radius, forKey: kCIInputRadiusKey)
            //
            if let outputImage:CIImage = ciFilter.outputImage {
                let cgimg:CGImage = context.createCGImage(outputImage, from: outputImage.extent)!
                let newImage:UIImage = UIImage.init(cgImage: cgimg, scale: self.scale, orientation: self.imageOrientation)
                return newImage
            }
        }
        
        return self
    }
    
    /**
     * É necessário que a imagem origem possua a propriedade 'CGImage' não nula e nenhuma de suas dimensões (largura ou altura) pode ser zero (0).
     *
     * @brief Detecta faces na imagem origem, criando uma lista a partir desta contendo subimagens dessas faces.
     * @warning Não é executado em imagens animadas.
     * @param handler Bloco de código que será executado ao fim da busca.
     * @note Por ser um processo potencialmente demorado, este método executa a detecção em background. Não há limite no tamanho da imagem para a busca nem na quantidade de faces que podem ser reportadas.
     */
    func detectFacesImages(completionHandler:@escaping (_ detectedFaces:[UIImage]) -> ()) -> () {
        
        if self.cgImage == nil || self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            completionHandler(Array())
        }
        
        DispatchQueue.global(qos: .background).async {
            
            let context = CIContext.init()
            let detectorOptions = [CIDetectorAccuracy:CIDetectorAccuracyHigh]
            let detector = CIDetector.init(ofType: CIDetectorTypeFace, context: context, options: detectorOptions)
            
            let featuresOptions = [CIDetectorImageOrientation:self.imageOrientation.rawValue]
            let ciImage = CIImage.init(cgImage: self.cgImage!)
            let features = detector?.features(in: ciImage, options: featuresOptions)
            
            var faces:[UIImage] = Array()
            
            if let fFeatures = features {
                for feature in fFeatures {
                    if let faceFeature = feature as? CIFaceFeature {
                        let originalBounds = faceFeature.bounds
                        var extendedBounds = originalBounds
                        
                        //face rect realign
                        if faceFeature.hasLeftEyePosition && faceFeature.hasRightEyePosition {
                            let dEyes = faceFeature.rightEyePosition.x - faceFeature.leftEyePosition.x
                            let side = dEyes * 3.5
                            //
                            let minX = min(faceFeature.leftEyePosition.x, faceFeature.rightEyePosition.x)
                            let maxX = max(faceFeature.leftEyePosition.x, faceFeature.rightEyePosition.x)
                            let minY = min(faceFeature.leftEyePosition.y, faceFeature.rightEyePosition.y)
                            let maxY = max(faceFeature.leftEyePosition.y, faceFeature.rightEyePosition.y)
                            //
                            let centerEyes = CGPoint.init(x: minX + ((maxX - minX) / 2.0), y: minY + ((maxY - minY) / 2.0))
                            extendedBounds = CGRect(x: CGFloat(centerEyes.x - (side / 2.0)), y: CGFloat(centerEyes.y - (side / 2.0)), width: CGFloat(side), height: CGFloat(side))
                        } else {
                            extendedBounds = CGRect(x: CGFloat(originalBounds.origin.x - ((originalBounds.size.width * 1.4 - originalBounds.size.width) / 2.0)), y: CGFloat(originalBounds.origin.y), width: CGFloat(originalBounds.size.width * 1.4), height: CGFloat(originalBounds.size.width * 2.0))
                        }
                        
                        let faceImage = self.cropImageUsingFrame(extendedBounds)
                        if faceImage != self {
                            faces.append(faceImage)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    completionHandler(faces)
                }
                
            } else {
                DispatchQueue.main.async {
                    completionHandler(Array())
                }
            }
        }
    }
    
    /**
     * É necessário que a imagem origem possua a propriedade 'CGImage' não nula e nenhuma de suas dimensões (largura ou altura) pode ser zero (0).
     *
     * @brief Detecta mensagem de texto na imagem, representados por QRCodes (cada QRCode na imagem vai gerar uma mensagem diferente).
     * @warning Não é executado em imagens animadas.
     * @param handler Bloco de código que será executado ao fim da busca.
     * @note Por ser um processo potencialmente demorado, este método executa a detecção em background. Não há limite no tamanho da imagem para a busca nem na quantidade de mensagens que podem ser reportadas.
     */
    func detectQRCodeMessages(completionHandler:@escaping (_ detectedMessages:[String]) -> ()) -> () {
        
        
        if self.cgImage == nil || self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            completionHandler(Array())
        }
        
        DispatchQueue.global(qos: .background).async {
            
            let context = CIContext.init()
            let detectorOptions = [CIDetectorAccuracy:CIDetectorAccuracyHigh]
            let detector = CIDetector.init(ofType: CIDetectorTypeQRCode, context: context, options: detectorOptions)
            
            let featuresOptions = [CIDetectorImageOrientation:self.imageOrientation.rawValue]
            let ciImage = CIImage.init(cgImage: self.cgImage!)
            let features = detector?.features(in: ciImage, options: featuresOptions)
            
            var messages:[String] = Array()
            
            if let mFeatures = features {
                for message in mFeatures {
                    if let messageFeature = message as? CIQRCodeFeature {
                        messages.append(messageFeature.messageString ?? "")
                    }
                }
                
                DispatchQueue.main.async {
                    completionHandler(messages)
                }
                
            } else {
                DispatchQueue.main.async {
                    completionHandler(Array())
                }
            }
        }
    }
        
    /**
     * Aplica o efeito "ChromaKey", utilizando o intervalo de HUE parâmetro.
     *
     * @brief O intervalo de cores definido pelo alcance HUE será removido da imagem (substituído por transparência).
     * @warning Não é executado em imagens animadas.
     * @param targetHue Valor entre 0 e 1 que representa o ângulo HUE para o qual se deseja aplicar o efeito, onde 0 corresponde a 0º e 1 a 360º.
     * @param tolerance Tolerância que será aplicada ao HUE alvo, para mais e para menos, para criação de um intervalo de cores. Igual ao parâmetro 'targetHue' também deve ser um valor entre 0 e 1, que representará o ângulo correspondente.
     * @return O retorno será uma cópia da imagem original, tendo todos os pixels afetados com suas cores substituídas por transparência.
     * @note Para saber mais sobre os valores Hue, veja o exemplo no endereço: 'https://en.wikipedia.org/wiki/Hue#/media/File:HueScale.svg'
     */
    func filterColor(targetHue:CGFloat, tolerance:CGFloat) -> UIImage {
        
        if self.cgImage == nil || self.isAnimated() {
            return self
        }
        
        let ciImage = CIImage.init(image: self)
        
        var minHue:CGFloat = targetHue - tolerance
        var maxHue:CGFloat = targetHue + tolerance
        
        minHue = minHue < 0.0 ? 0.0 : minHue
        maxHue = maxHue > 1.0 ? 1.0 : maxHue
        
        let size = 64
        var cubeData = [Float](repeating: 0, count: size * size * size * 4)
        var rgb: [Float] = [0, 0, 0]
        var hsv: (h : Float, s : Float, v : Float)
        var offset = 0
        
        for z in 0 ..< size {
            rgb[2] = Float(z) / Float(size) // blue value
            for y in 0 ..< size {
                rgb[1] = Float(y) / Float(size) // green value
                for x in 0 ..< size {
                    rgb[0] = Float(x) / Float(size) // red value
                    hsv = RGBtoHSV(r: rgb[0], g: rgb[1], b: rgb[2])
                    // the condition checking hsv.s may need to be removed for your use-case
                    let alpha: Float = (CGFloat(hsv.h) > minHue && CGFloat(hsv.h) < maxHue && hsv.s > 0.5) ? 0 : 1.0
                    //
                    cubeData[offset] = rgb[0] * alpha
                    cubeData[offset + 1] = rgb[1] * alpha
                    cubeData[offset + 2] = rgb[2] * alpha
                    cubeData[offset + 3] = alpha
                    offset += 4
                }
            }
        }
        let b = cubeData.withUnsafeBufferPointer { Data(buffer: $0) }
        let data = b as NSData
        
        if let ciFilter:CIFilter = CIFilter.init(name: "CIColorCube") {
            ciFilter.setValue(size, forKey: "inputCubeDimension")
            ciFilter.setValue(data, forKey: "inputCubeData")
            ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
            //
            if let outputImage:CIImage = ciFilter.outputImage {
                let context = CIContext.init()
                let cgimg:CGImage = context.createCGImage(outputImage, from: outputImage.extent)!
                let newImage:UIImage = UIImage.init(cgImage: cgimg, scale: self.scale, orientation: self.imageOrientation)
                return newImage
            }
        }
        
        return self
    }
    
    /**
     * Este método transforma uma cor em outra, dentro de uma área de interesse.
     *
     * @brief O intervalo de cores é criado pela tolerância parâmetro, na busca, e o HUE da cor destino define a aparência final.
     * @warning Não é executado em imagens animadas.
     * @param from Cor alvo, que se deseja alterar.
     * @param to Cor destino, para a qual se deseja transformar a cor alvo.
     * @param tolerance Fator que define a precisão na busca pela cor alvo (são considerados Hue, Saturation, Brightness, Alpha). Aceita valores entre 0 e 1.
     * @param interestAreas Quando fornecido define as áreas de atuação do efeito. Ignore para buscar em toda a imagem.
     * @return O retorno será uma cópia da imagem original, com as cores transmutadas nos pontos atingidos pelas regras.
     * @note Para saber mais sobre os valores Hue, veja o exemplo no endereço: 'https://en.wikipedia.org/wiki/Hue#/media/File:HueScale.svg'
     */
    func transmuteColor(from:UIColor, to:UIColor, tolerance:CGFloat, interestAreas:[CGRect]?) -> UIImage {
        
        if self.cgImage == nil || self.isAnimated() {
            return self
        }
        
        let workImage = UIImage(data: self.pngData()!)!
        
        let imageRef = workImage.cgImage!
        let width = imageRef.width
        let height = imageRef.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let context = CGContext.init(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        context?.draw(imageRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var byteIndex = 0
        
        //FROM COLOR
        var hueFrom : CGFloat = 0
        var saturationFrom : CGFloat = 0
        var brightnessFrom : CGFloat = 0
        var transparencyFrom : CGFloat = 0
        from.getHue(&hueFrom, saturation: &saturationFrom, brightness: &brightnessFrom, alpha: &transparencyFrom)
        
        //TO COLOR
        var hueTo : CGFloat = 0
        var saturationTo : CGFloat = 0
        var brightnessTo : CGFloat = 0
        var transparencyTo : CGFloat = 0
        to.getHue(&hueTo, saturation: &saturationTo, brightness: &brightnessTo, alpha: &transparencyTo)
        
        for i in 0 ..< (width * height) {
            
            var needCalculation = false
            if let area = interestAreas {
                let actualPixel = CGPoint(x: i % width, y: i / width) //A conversão em linhas e colunas usa os valores de X e Y invertidos
                for rect in area {
                    if rect.contains(actualPixel) {
                        needCalculation = true
                        break
                    }
                }
            } else {
                needCalculation = true
            }
            
            if needCalculation {
                
                //ACTUAL COLOR (0~255 range)
                let red = CGFloat(context!.data!.load(fromByteOffset: (byteIndex + 0), as: UInt8.self))
                let green = CGFloat(context!.data!.load(fromByteOffset: (byteIndex + 1), as: UInt8.self))
                let blue = CGFloat(context!.data!.load(fromByteOffset: (byteIndex + 2), as: UInt8.self))
                let alpha = CGFloat(context!.data!.load(fromByteOffset: (byteIndex + 3), as: UInt8.self))
                //
                var hueActual : CGFloat = 0
                var saturationActual : CGFloat = 0
                var brightnessActual : CGFloat = 0
                var transparencyActual : CGFloat = 0
                let actualColor = UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha/255.0)
                actualColor.getHue(&hueActual, saturation: &saturationActual, brightness: &brightnessActual, alpha: &transparencyActual)
                
                if self.compareValues(v1:hueFrom, v2:hueActual, delta:tolerance) {
                    if self.compareValues(v1:saturationFrom, v2:saturationActual, delta:tolerance) {
                        if self.compareValues(v1:brightnessFrom, v2:brightnessActual, delta:tolerance) {
                            if self.compareValues(v1:transparencyFrom, v2:transparencyActual, delta:tolerance) {
                                
                                //TRANSMUTED COLOR
                                let transmutedColor = UIColor.init(hue: hueTo, saturation: saturationActual, brightness: brightnessActual, alpha: transparencyActual)
                                var tRed: CGFloat = 0, tGreen: CGFloat = 0, tBlue: CGFloat = 0, tAlpha: CGFloat = 0
                                transmutedColor.getRed(&tRed, green: &tGreen, blue: &tBlue, alpha: &tAlpha)
                                
                                //R:
                                let storeRed = UInt8.init(tRed * 255.0)
                                context!.data!.storeBytes(of: storeRed, toByteOffset: (byteIndex + 0), as: UInt8.self)
                                //G:
                                let storeGreen = UInt8.init(tGreen * 255.0)
                                context!.data!.storeBytes(of: storeGreen, toByteOffset: (byteIndex + 1), as: UInt8.self)
                                //B:
                                let storeBlue = UInt8.init(tBlue * 255.0)
                                context!.data!.storeBytes(of: storeBlue, toByteOffset: (byteIndex + 2), as: UInt8.self)
                                //A:
                                let storeAlpha = UInt8.init(tAlpha * 255.0)
                                context!.data!.storeBytes(of: storeAlpha, toByteOffset: (byteIndex + 3), as: UInt8.self)
                            }
                        }
                    }
                }
            }
            
            byteIndex += bytesPerPixel
        }
        
        //draw final image
        if let cgImage = context?.makeImage() {
            return UIImage.init(cgImage: cgImage)
        }
        
        return self
    }
    
    
    //******************************************************************************************************
    //MARK: - INFO
    //******************************************************************************************************
    
    /**
     * Este método desenha o texto na imagem, fazendo uso das configurações disponíveis.
     *
     * @brief Cria uma nova imagem com o texto parâmetro renderizado.
     * @warning Não é executado em imagens animadas.
     * @param text Texto que se deseja renderizar.
     * @param rect Área dentro da imagem onde o texto deve ser desenhado.
     * @param rectCorners Cantos que se deseja aplicar arredondamento ao desenhar o rect.
     * @param cornerSize Raio dos cantos, quando forem utilizados.
     * @param textAligment Alinhamento horizontal do texto.
     * @param margin Margem interna, relacionada ao rect, aplicada ao texto na renderização. Bom para impedir que o texto "grude" nas laterais do rect quando for utilizado alinhamento a direita ou esquerda.
     * @param font Fonte que se deseja utilizar no desenho do texto.
     * @param fontColor Cor da fonte.
     * @param backColor Cor de fundo para a área do texto (rect). Pode ter cantos arredondados.
     * @param shadow Parâmetro opcional aplicado ao texto, contento opção de cor, offset e dissipação para a sombra.
     * @param adjust Quando verdadeiro, irá reajustar a altura de rect, para fazer com que a área compreenda a altura necessária para o texto parâmetro.
     * @return Retorna uma nova imagem com o texto renderizado.
     */
    func labeledImage(text:String, contentRect:CGRect, rectCorners:UIRectCorner, cornerSize:CGSize, textAligment:NSTextAlignment, internalMargin:UIEdgeInsets, font:UIFont, fontColor:UIColor, backgroundColor:UIColor?, shadow:NSShadow?, autoHeightAdjust:Bool) -> UIImage {
        
        if self.cgImage == nil || self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height))
        
        var textRect = contentRect
        
        let label = NSString.init(string: text)
        
        let constraintRect = CGSize(width: contentRect.size.width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = label.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:font], context: nil)
        
        if autoHeightAdjust {
            textRect = CGRect(x: textRect.origin.x, y: textRect.origin.y, width: textRect.size.width, height: boundingBox.size.height)
        }
        
        //RECT
        if let backColor = backgroundColor {
            let rounded = UIBezierPath(roundedRect: textRect, byRoundingCorners: rectCorners, cornerRadii: cornerSize)
            backColor.setFill()
            rounded.fill()
        }
        
        if boundingBox.size.height <= textRect.size.height {
            textRect = CGRect(x: textRect.origin.x, y: textRect.origin.y + (textRect.size.height - boundingBox.size.height) / 2.0, width: textRect.size.width, height: textRect.size.height)
        }
        
        //INTERNAL_MARGIN
        textRect = CGRect(x: textRect.origin.x + internalMargin.left, y: textRect.origin.y + internalMargin.top, width: textRect.size.width - (internalMargin.left + internalMargin.right), height: textRect.size.height - (internalMargin.top + internalMargin.bottom))
        
        //TEXT
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.alignment = textAligment
        paragraphStyle.minimumLineHeight = font.pointSize
        paragraphStyle.maximumLineHeight = font.pointSize * 1.5
        paragraphStyle.lineBreakMode = .byWordWrapping
        //
        var attributes:Dictionary<NSAttributedString.Key, Any> = Dictionary()
        attributes[NSAttributedString.Key.font] = font
        attributes[NSAttributedString.Key.foregroundColor] = fontColor
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        if let shadowText = shadow {
            attributes[NSAttributedString.Key.shadow] = shadowText
        }
        //
        label.draw(in: textRect, withAttributes: attributes)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage ?? self
    }
    
    //******************************************************************************************************
    //MARK: - PRIVATE FUNCTIONS (UTILS AND SUPPORT)
    //******************************************************************************************************
    
    private class func delayCentisecondsForImageAtIndex(source:CGImageSource, index:Int) -> Int {
        
        var delayCentiseconds:Int = 1
        
        if let properties:CFDictionary = CGImageSourceCopyPropertiesAtIndex(source, index, nil) {
            
            let key = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
            if let pointer:UnsafeRawPointer = CFDictionaryGetValue(properties, key) {
                
                let gifProperties:CFDictionary = unsafeBitCast(pointer, to:CFDictionary.self)
                
                let key2 = Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()
                if let pointer2:UnsafeRawPointer = CFDictionaryGetValue(gifProperties, key2) {
                    
                    var value = unsafeBitCast(pointer2, to:AnyObject.self).doubleValue
                    
                    if value == nil || value == 0 {
                        let key3 = Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()
                        if let pointer3:UnsafeRawPointer = CFDictionaryGetValue(gifProperties, key3) {
                            value = unsafeBitCast(pointer3, to:AnyObject.self).doubleValue
                        }
                    }
                    
                    if let v = value {
                        if v > 0.0 {
                            // Even though the GIF stores the delay as an integer number of centiseconds, ImageIO “helpfully” converts that to seconds for us.
                            delayCentiseconds = lrint(v * 100.0)
                        }
                    }
                }
            }
        }
        return delayCentiseconds
        
    }
    
    private class func createImagesAndDelays(source:CGImageSource, count:Int, imagesOut:inout [CGImage], delayCentisecondsOut:inout [Int]) -> () {
        for i in 0 ..< count {
            imagesOut.append(CGImageSourceCreateImageAtIndex(source, i, nil)!)
            delayCentisecondsOut.append(delayCentisecondsForImageAtIndex(source: source, index: i))
        }
    }
    
    private class func sum(values:[Int]) -> Int {
        var theSum:Int = 0
        for i in 0 ..< values.count {
            theSum += values[i]
        }
        return theSum
    }
    
    private class func pairGCD(_ a:Int, _ b:Int) -> Int {
        if a < b {
            return pairGCD(b, a)
        }
        //
        var A = a
        var B = b
        //
        while true {
            let r:Int = A % B
            if r == 0 {
                return B
            }
            A = B
            B = r
        }
    }
    
    private class func vectorGCD(count:Int, values:[Int]) -> Int {
        var gcd = values[0]
        for i in 1 ..< count {
            // Note that after I process the first few elements of the vector, `gcd` will probably be smaller than any remaining element.  By passing the smaller value as the second argument to `pairGCD`, I avoid making it swap the arguments.
            gcd = pairGCD(values[i], gcd)
        }
        return gcd
    }
    
    private class func frameArray(count:Int, images:[CGImage], delayCentiseconds:[Int], totalDurationCentiseconds:Int) -> Array<UIImage> {
        
        let gcd:Int = vectorGCD(count: count, values: delayCentiseconds)
        var _:Int = totalDurationCentiseconds / gcd
        var frames:[UIImage] = Array()
        //
        for i in 0 ..< count {
            let frame:UIImage = UIImage.init(cgImage: images[i])
            let start:Int = delayCentiseconds[i] / gcd
            let end:Int = 0
            for _ in stride(from: start, to: end, by: -1) {
                frames.append(frame)
            }
        }
        //
        return frames
    }
    
    private func circularCrop(image:UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: image.size.width, height: image.size.height), false, image.scale)
        let context = UIGraphicsGetCurrentContext()
        //Get the width and heights
        let rectWidth = image.size.width
        let rectHeight = image.size.height
        //Calculate the centre of the circle
        let imageCentreX = rectWidth / 2.0
        let imageCentreY = rectHeight / 2.0
        // Create and CLIP to a CIRCULAR Path
        // (This could be replaced with any closed path if you want a different shaped clip)
        let radius = min(rectWidth, rectHeight) / 2.0
        context?.beginPath()
        context?.addArc(center: CGPoint.init(x: imageCentreX, y: imageCentreY), radius: radius, startAngle: 0, endAngle: CGFloat.init(Float.pi * 2.0), clockwise: false)
        context?.closePath()
        context?.clip()
        // Draw the IMAGE
        let finalRect = CGRect.init(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
        image.draw(in: finalRect)
        
        let finalImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return finalImage ?? image
    }
    
    private func roundedRect(image:UIImage, radius:CGFloat, corners:UIRectCorner) -> UIImage {
        let rounded:UIBezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height), byRoundingCorners: corners, cornerRadii: CGSize.init(width: radius, height: radius))
        //
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: image.size.width, height: image.size.height), false, image.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.beginPath()
        context?.addPath(rounded.cgPath)
        context?.closePath()
        context?.clip()
        //
        let rect = CGRect.init(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
        image.draw(in: rect)
        //
        let finalImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage ?? image
    }
    
    private func clipping(image:UIImage, path:CGPath) -> UIImage {
        
        let boxPath:CGRect = path.boundingBox
        //
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: image.size.width, height: image.size.height), false, image.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.beginPath()
        context?.addPath(path)
        context?.closePath()
        context?.clip()
        //
        let rect = CGRect.init(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
        image.draw(in: rect)
        
        let tempImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        if let tImage = tempImage {
            let finalImage:UIImage = tImage.cropImageUsingFrame(boxPath)
            return finalImage
        }
        
        return image        
    }
    
    private func compress(image:UIImage, quality:CGFloat) -> UIImage {
        if quality == 1.0 {
            //Lossless compression
            if let data:Data = image.pngData() {
                let img:UIImage? = UIImage.init(data: data)
                return img ?? image
            }
        } else {
            //Lossy compression (remove transparency)
            if let data:Data = image.jpegData(compressionQuality: quality) {
                let img:UIImage? = UIImage.init(data: data)
                return img ?? image
            }
        }
        return image
    }
    
    private class func animatedImageWithAnimatedGIFImageSource(source:CGImageSource) -> UIImage {
        let count = CGImageSourceGetCount(source)
        var images:[CGImage] = Array()
        var delayCentiseconds:[Int] = Array()
        createImagesAndDelays(source: source, count: count, imagesOut: &images, delayCentisecondsOut: &delayCentiseconds)
        let totalDurationCentiseconds:Int = sum(values: delayCentiseconds)
        let frames = frameArray(count: count, images: images, delayCentiseconds: delayCentiseconds, totalDurationCentiseconds: totalDurationCentiseconds)
        let animation:UIImage = UIImage.animatedImage(with: frames, duration: TimeInterval.init(Float.init(totalDurationCentiseconds) / 100.0))!
        //
        return animation
    }
    
    private func radians(fromDegrees:CGFloat) -> CGFloat {
        return fromDegrees * CGFloat.init(Float.pi / 180.0)
    }
    
    private func degrees(fromRadians:CGFloat) -> CGFloat {
        return fromRadians * CGFloat.init(180.0 / Float.pi)
    }
    
    private func hueFromColor(red:CGFloat, green:CGFloat, blue:CGFloat) -> CGFloat {
        let color = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
        var hue: CGFloat = 0
        color.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        //
        return hue
    }
    
    private func RGBtoHSV(r : Float, g : Float, b : Float) -> (h : Float, s : Float, v : Float) {
        var h : CGFloat = 0
        var s : CGFloat = 0
        var v : CGFloat = 0
        let col = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
        col.getHue(&h, saturation: &s, brightness: &v, alpha: nil)
        return (Float(h), Float(s), Float(v))
    }
    
    private func clamp255(_ value:CGFloat) -> CGFloat {
        return value < 0.0 ? 0.0 : (value > 255.0 ? 255.0 : value)
    }
    
    private func compareValues(v1:CGFloat, v2:CGFloat, delta:CGFloat) -> Bool {
//        let minV2 = v2 - (v2 * delta)
//        let maxV2 = v2 + (v2 * delta)
//        return (v1 >= minV2 && v1 <= maxV2)
        let minV2 = v2 - delta
        let maxV2 = v2 + delta
        return (v1 >= minV2 && v1 <= maxV2)
    }
    
   
}
