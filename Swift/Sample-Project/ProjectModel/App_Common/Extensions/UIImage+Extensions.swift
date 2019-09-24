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
import CoreGraphics

enum ContrastIntensity:UInt {
    case normal     = 0
    case low        = 1
    case high       = 2
}

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
        if let data:Data = self.jpegData(compressionQuality: 1.0) {
            return data.base64EncodedString(options: .endLineWithLineFeed)
        }
        return nil
    }
    
    func encodeToBase64String(asJPEG: Bool, options: Data.Base64EncodingOptions, appendPrefix: Bool) -> String? {
        if (self.isAnimated()){
            return nil
        }
        //
        if asJPEG {
            if let data:Data = self.jpegData(compressionQuality: 1.0) {
                if appendPrefix {
                    return "data:image/jpeg;base64," + data.base64EncodedString(options: options)
                } else {
                    return data.base64EncodedString(options: options)
                }
            }
        } else {
            if let data:Data = self.pngData() {
                if appendPrefix {
                    return "data:image/png;base64," + data.base64EncodedString(options: options)
                } else {
                    return data.base64EncodedString(options: options)
                }
            }
        }
        
        return nil
    }
    
    /**
     * Copia a imagem, incluindo a animação, se existir.
     * - Returns: Retorna uma nova instância cópia do objeto imagem original.
     */
    func clone() -> UIImage {
        
        //copiando animações:
        if self.isAnimated() {
            var iList:[UIImage] = Array()
            for image in self.images! {
                let copy = image.clone()
                iList.append(copy)
            }
            let newImage:UIImage? = UIImage.animatedImage(with: iList, duration: self.duration)
            return newImage ?? self
        }
        
        //copiando imagem única:
        if let data = self.pngData() {
            return UIImage.init(data: data)!
        }
        
        return self
    }
    
    /**
     * Cria o `thumbnail` da imagem.
     * - Parameter maxPixelSize: Máxima dimensão que o thumb deve ter.
     * - Returns: Retorna uma nova instância cópia do objeto imagem original.
     */
    func createThumbnail(_ maxPixelSize:UInt) -> UIImage {
        
        if self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            return self
        }
        
        if let data = self.pngData() {
            let imageSource:CGImageSource = CGImageSourceCreateWithData(data as CFData, nil)!
            //
            var options: [NSString:Any] = Dictionary()
            options[kCGImageSourceThumbnailMaxPixelSize] = maxPixelSize
            options[kCGImageSourceCreateThumbnailFromImageAlways] = true
            //
            if let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) {
                let finalImage = UIImage.init(cgImage: scaledImage)
                return finalImage
            }
        }
        
        return self
    }
    
    /**
     * Cria uma imagem retangular, podendo ter cantos arredondados.
     * - Parameter size: Dimensão desejada para a imagem.
     * - Parameter corners: Cantos que se deseja arredondar.
     * - Parameter cornerRadius: Raio que se deseja aplicar aos cantos.
     * - Parameter color: Cor que se deseja para imagem (o alpha deve estar incluso).
     * - Returns: Retorna uma nova instância de UIImage, com as características parâmetro.
     */
    class func createFlatImage(size:CGSize, corners:UIRectCorner, cornerRadius:CGSize, color:UIColor) -> UIImage{
        
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        let path:UIBezierPath = UIBezierPath.init(roundedRect: rect , byRoundingCorners: corners, cornerRadii: cornerRadius)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        path.fill()
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //
        return image
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
     * - Brief: Instancia uma imagem animada de um arquivo tipo GIF.
     * - Warning: É necessário que o arquivo carregado seja do tipo GIF para que a animação seja processada corretamente.
     * - Parameter data: Objeto NSData do arquivo de imagem.
     * - Returns: Retorna Uma nova imagem animada.
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
     * - Brief: Instancia uma imagem animada de um arquivo tipo GIF, referenciado pela URL do arquivo.
     * - Warning: É necessário que o arquivo carregado seja do tipo GIF para que a animação seja processada corretamente.
     * - Parameter url: URL do arquivo. Se \c theURL não for um arquivo local é aconselhável que a chamada seja feita em background para evitar o bloqueio da thread principal.
     * - Returns: Retorna Uma nova imagem animada.
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
     * - Brief: Instancia uma imagem animada utilizando uma lista de imagens (frames) e tempos (timeFrames).
     * - Warning: É necessário que as imagens da lista parâmetro possuam a mesma dimensão e escala. Além disso, cada imagem precisa ter a propriedade 'CGImage' não nula e o número de imagens e tempos sejam equivalentes.
     * - Parameter  images: Cada imagem desta lista será um ou vários frames da animação final.
     * - Parameter  durations: Cada duração desta lista representa a parcela de tempo que uma imagem deve ficar visível na animação.
     * - Returns: Retorna um objeto UIImage animado.
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
     * - Returns: O retorno será 'true' para imagens animadas e 'false' para imagens normais.
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
     * - Brief: Cria uma nova imagem com orientação modificada (UIImageOrientationUp).
     * - Warning: Não é executado em imagens animadas.
     * - Returns: Retorna uma cópia alterada da imagem origem. Caso o método não consiga executar a transformação, será retornada a própria imagem original.
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
     * - Brief: Cria uma nova imagem rotacionada no sentido horário.
     * - Warning: Não é executado em imagens animadas.
     * - Returns: Retorna uma cópia alterada da imagem origem. Caso o método não consiga executar a transformação, será retornada a própria imagem original.
     * @note Utilize o método \p <imageRotatedByDegrees:> para ângulos arbitrários.
     */
    func imageRotatedClockwise() -> UIImage {
        return imageRotated(byDegrees: 90.0)
    }
    
    /**
     * É necessário que a imagem origem possua a propriedade 'CGImage' não nula e nenhuma de suas dimensões (largura ou altura) pode ser zero (0).
     *
     * - Brief: Cria uma nova imagem rotacionada no sentido antihorário.
     * - Warning: Não é executado em imagens animadas.
     * - Returns: Retorna uma cópia alterada da imagem origem. Caso o método não consiga executar a transformação, será retornada a própria imagem original.
     * @note Utilize o método \p <imageRotatedByDegrees:> para ângulos arbitrários.
     */
    func imageRotatedCounterClockwise() -> UIImage {
        return imageRotated(byDegrees: -90.0)
    }
    
    /**
     * É necessário que a imagem origem possua a propriedade 'CGImage' não nula e nenhuma de suas dimensões (largura ou altura) pode ser zero (0).
     *
     * - Brief: Cria uma nova imagem rotacionada num ângulo arbitrário.
     * - Warning: Não é executado em imagens animadas.
     * - Parameter  byDegrees: Ângulo, em graus, que se deseja girar a imagem. Pode ser negativo.
     * - Returns: Retorna uma cópia alterada da imagem origem. Caso o método não consiga executar a transformação, será retornada a própria imagem original.
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
     * - Brief: Cria uma nova imagem horizontalmente espelhada.
     * - Warning: Não é executado em imagens animadas.
     * - Returns: Retorna uma cópia alterada da imagem origem. Caso o método não consiga executar a transformação, será retornada a própria imagem original.
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
     * - Brief: Cria uma nova imagem verticalmente espelhada.
     * - Warning: Não é executado em imagens animadas.
     * - Returns: Retorna uma cópia alterada da imagem origem. Caso o método não consiga executar a transformação, será retornada a própria imagem original.
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
        
        let width = self.size.width
        let height = self.size.height
        let ratio = width / height
        
        let scale = UIScreen.main.nativeScale
        let frameWidth = frameSize.width * scale
        let frameHeight = frameSize.height * scale
        let frameRatio = frameWidth / frameHeight
        
        //Inicia-se supondo que a imagem usa left/right
        var idealWidth:CGFloat = frameWidth
        var idealHeight:CGFloat = idealWidth / ratio
        
        //Caso contrário a imagem usa top/bottom
        if ratio < frameRatio {
            idealHeight = frameHeight
            idealWidth = idealHeight * ratio
        }
        
        let newSize = CGSize.init(width: idealWidth, height: idealHeight)
        return self.resizedImageToSize(newSize)
        
        
//        var width = self.size.width
//        var height = self.size.height
//        let ratio = width / height
//        let scale = UIScreen.main.nativeScale
//        let maxWidth = frameSize.width * scale
//        let maxHeight = frameSize.height * scale
//        //
//        if width > maxWidth {
//            width = maxWidth
//            height = width / ratio
//        } else if height > maxHeight {
//            height = maxHeight
//            width = height * ratio
//        }
//        //
//        let newSize = CGSize.init(width: width, height: height)
//        return self.resizedImageToSize(newSize)
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
    
    /** Cria uma imagem branco e preto a partir da imagem original, permitindo utilizar 3 níveis de contraste. */
    func monochromaticBWImage(intensity:ContrastIntensity) -> UIImage {
        
        let ciImage:CIImage = CIImage.init(image: self)!
        let context:CIContext = CIContext.init()
        //
        var filterName = ""
        switch intensity {
        case .normal:
            filterName = "CIPhotoEffectTonal"
            break
        case .low:
            filterName = "CIPhotoEffectMono"
            break
        case .high:
            filterName = "CIPhotoEffectNoir"
            break
        }
        
        if let ciFilter:CIFilter = CIFilter.init(name: filterName) {
            //In case no parameter is passed, the input image will already be in the filter by default:
            ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
            //
            if let outputImage:CIImage = ciFilter.outputImage {
                let cgimg:CGImage = context.createCGImage(outputImage, from: outputImage.extent)!
                let newImage:UIImage = UIImage.init(cgImage: cgimg, scale: self.scale, orientation: self.imageOrientation)
                return newImage
            }
        }
        
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
    
    /** Adiciona o efeito GaussianBlur em uma nova instância da imagem. */
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
     * - Brief: Detecta faces na imagem origem, criando uma lista a partir desta contendo subimagens dessas faces.
     * - Warning: Não é executado em imagens animadas.
     * - Parameter  completionHandler: Bloco de código que será executado ao fim da busca.
     * @note Por ser um processo potencialmente demorado, este método executa a detecção em background. Não há limite no tamanho da imagem para a busca nem na quantidade de faces que podem ser reportadas.
     */
    func detectFacesImages(completionHandler:@escaping (_ detectedFaces:[UIImage]) -> ()) -> () {
        
        if self.cgImage == nil || self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            completionHandler(Array())
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            
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
     * - Brief: Detecta mensagem de texto na imagem, representados por QRCodes (cada QRCode na imagem vai gerar uma mensagem diferente).
     * - Warning: Não é executado em imagens animadas.
     * - Parameter  completionHandler: Bloco de código que será executado ao fim da busca.
     * @note Por ser um processo potencialmente demorado, este método executa a detecção em background. Não há limite no tamanho da imagem para a busca nem na quantidade de mensagens que podem ser reportadas.
     */
    func detectQRCodeMessages(completionHandler:@escaping (_ detectedMessages:[String]) -> ()) -> () {
        
        
        if self.cgImage == nil || self.size.width == 0 || self.size.height == 0 || self.isAnimated() {
            completionHandler(Array())
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            
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
     * - Brief: O intervalo de cores definido pelo alcance HUE será removido da imagem (substituído por transparência).
     * - Warning: Não é executado em imagens animadas.
     * - Parameter  targetHue: Valor entre 0 e 1 que representa o ângulo HUE para o qual se deseja aplicar o efeito, onde 0 corresponde a 0º e 1 a 360º.
     * - Parameter  tolerance: Tolerância que será aplicada ao HUE alvo, para mais e para menos, para criação de um intervalo de cores. Igual ao parâmetro 'targetHue' também deve ser um valor entre 0 e 1, que representará o ângulo correspondente.
     * - Returns: O retorno será uma cópia da imagem original, tendo todos os pixels afetados com suas cores substituídas por transparência.
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
     * - Brief: O intervalo de cores é criado pela tolerância parâmetro, na busca, e o HUE da cor destino define a aparência final.
     * - Warning: Não é executado em imagens animadas.
     * - Parameter  from: Cor alvo, que se deseja alterar.
     * - Parameter  to: Cor destino, para a qual se deseja transformar a cor alvo.
     * - Parameter  tolerance: Fator que define a precisão na busca pela cor alvo (são considerados Hue, Saturation, Brightness, Alpha). Aceita valores entre 0 e 1.
     * - Parameter  interestAreas: Quando fornecido define as áreas de atuação do efeito. Ignore para buscar em toda a imagem.
     * - Returns: O retorno será uma cópia da imagem original, com as cores transmutadas nos pontos atingidos pelas regras.
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
     * - Brief: Cria uma nova imagem com o texto parâmetro renderizado.
     * - Warning: Não é executado em imagens animadas.
     * - Parameter  text: Texto que se deseja renderizar.
     * - Parameter  contentRect: Área dentro da imagem onde o texto deve ser desenhado.
     * - Parameter  rectCorners: Cantos que se deseja aplicar arredondamento ao desenhar o rect.
     * - Parameter  cornerSize: Raio dos cantos, quando forem utilizados.
     * - Parameter  textAligment: Alinhamento horizontal do texto.
     * - Parameter  internalMargin: Margem interna, relacionada ao rect, aplicada ao texto na renderização. Bom para impedir que o texto "grude" nas laterais do rect quando for utilizado alinhamento a direita ou esquerda.
     * - Parameter  font: Fonte que se deseja utilizar no desenho do texto.
     * - Parameter  fontColor: Cor da fonte.
     * - Parameter  backgroundColor: Cor de fundo para a área do texto (rect). Pode ter cantos arredondados.
     * - Parameter  shadow: Parâmetro opcional aplicado ao texto, contento opção de cor, offset e dissipação para a sombra.
     * - Parameter  autoHeightAdjust: Quando verdadeiro, irá reajustar a altura de rect, para fazer com que a área compreenda a altura necessária para o texto parâmetro.
     * - Returns: Retorna uma nova imagem com o texto renderizado.
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
    
    /**
     * Este método extrai da imagem as cores mais relevantes (conforme parâmetros).
     *
     * - Brief: Cria uma lista de cores após processamento da imagem.
     * - Warning: Em imagens animadas somente o primeiro frame será considerado.
     * - Parameter  withFlags: Parâmetros a serem utilizados na busca.
     * - Parameter  avoidColor: Cor opcional que será ignorada na busca. É necessário que a cor possua todos os parâmetros RGA, por isso utilize `UIColor.init(red:green:blue:alpha:)`.
     * - Parameter  count: Limita o resultado apenas para as cores mais relevantes.
     * - Parameter  completionHandler: Bloco de código que será executado ao final do processamento.
     * - Parameter  colors: Lista com as cores extraídas. A quantidade máxima pode ser limitada pelo parâmetro `count`.
     */
    public func extractColors(withFlags flags: [CCFlags], avoidColor: UIColor?, count: Int, completionHandler:@escaping (_ colors:[UIColor]) -> ()) -> Void {
        DispatchQueue.global(qos: .userInteractive).async {
            let colorCube = CCColorCube()
            var sortedMaxima = colorCube.findAndSortMaxima(inImage: self, flags: flags)
            if let avoidColor = avoidColor {
                sortedMaxima = colorCube.filter(maxima: sortedMaxima, tooCloseToColor: avoidColor)
            }
            sortedMaxima = colorCube.performAdaptiveDistinctFiltering(forMaxima: sortedMaxima, count: count)
            let colors = colorCube.colors(fromMaxima: sortedMaxima)
            //
            DispatchQueue.main.async {
                completionHandler(colors)
            }
        }
    }
    
    /**
     * Este método busca a cor de um pixel específico na imagem.
     * - Warning: A imagem deve ter a propriedade 'cgImage' válida.
     * - Parameter  atLocation: Posição do pixel que se deseja obter a informação de cor.
     * - Returns: Cor do pixel, quando a posição na imagem for válida.
     */
    public func pixelColor(atLocation:CGPoint) -> UIColor? {
        let boundRect = CGRect.init(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        if !boundRect.contains(atLocation) || self.cgImage == nil {
            return nil
        }
        //
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(atLocation.y)) + Int(atLocation.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
        
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
            if let data:Data = self.pngData() {
                let img:UIImage? = UIImage.init(data: data)
                return img ?? image
            }
        } else {
            //Lossy compression (remove transparency)
            if let data:Data = self.jpegData(compressionQuality: quality) {
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

//MARK: - COLOR CUBE - ORIGINAL CODE: https://github.com/YamiDaisuke/ColorCubeSwift

fileprivate struct CCCubeCell {
    var hitCount: Int = 0
    
    var redAcc: CGFloat = 0.0
    var greenAcc: CGFloat = 0.0
    var blueAcc: CGFloat = 0.0
}

public enum CCFlags: OptionBits {
    public typealias RawValue = UInt32
    
    // This ignores all pixels that are darker than a threshold
    case onlyBrightColors   = 1
    
    // This ignores all pixels that are brighter than a threshold
    case onlyDarkColors     = 2
    
    // This filters the result array so that only distinct colors are returned
    case onlyDistinctColors = 4
    
    // This orders the result array by color brightness (first color has highest brightness). If not set,
    // colors are ordered by frequency (first color is "most frequent").
    case orderByBrightness  = 8
    
    // This orders the result array by color darkness (first color has lowest brightness). If not set,
    // colors are ordered by frequency (first color is "most frequent").
    case orderByDarkness    = 16
    
    // Removes colors from the result if they are too close to white
    case avoidWhite         = 32
    
    // Removes colors from the result if they are too close to black
    case avoidBlack         = 64
}

fileprivate class CCLocalMaximum: NSObject {
    
    // Hit count of the cell
    var hitCount: Int = 0
    
    // Linear index of the cell
    var cellIndex: Int = 0
    
    // Average color of cell
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    // Maximum color component value of average color
    var brightness: CGFloat = 0.0
}

fileprivate class CCColorCube: NSObject {
    
    // The cell resolution in each color dimension
    private static let COLOR_CUBE_RESOLUTION: Int = 32 //30
    private static let COLOR_CUBE_RESOLUTION_GCFLOAT: CGFloat = 32 //30
    
    // Threshold used to filter bright colors
    private static let BRIGHT_COLOR_THRESHOLD: CGFloat = 0.6
    
    // Threshold used to filter dark colors
    private static let DARK_COLOR_THRESHOLD = 0.4
    
    // Threshold (distance in color space) for distinct colors
    private static let DISTINCT_COLOR_THRESHOLD: CGFloat = 0.2
    
    // Helper macro to compute linear index for cells
    // private class func CELL_INDEX(r,g,b) (r+g*COLOR_CUBE_RESOLUTION+b*COLOR_CUBE_RESOLUTION*COLOR_CUBE_RESOLUTION)
    
    // Helper macro to get total count of cells
    // let CELL_COUNT COLOR_CUBE_RESOLUTION*COLOR_CUBE_RESOLUTION*COLOR_CUBE_RESOLUTION
    
    
    // Indices for neighbour cells in three dimensional grid
    private static let neighbourIndices: [[Int]] = [
        [ 0, 0, 0],
        [ 0, 0, 1],
        [ 0, 0,-1],
        
        [ 0, 1, 0],
        [ 0, 1, 1],
        [ 0, 1,-1],
        
        [ 0,-1, 0],
        [ 0,-1, 1],
        [ 0,-1,-1],
        
        [ 1, 0, 0],
        [ 1, 0, 1],
        [ 1, 0,-1],
        
        [ 1, 1, 0],
        [ 1, 1, 1],
        [ 1, 1,-1],
        
        [ 1,-1, 0],
        [ 1,-1, 1],
        [ 1,-1,-1],
        
        [-1, 0, 0],
        [-1, 0, 1],
        [-1, 0,-1],
        
        [-1, 1, 0],
        [-1, 1, 1],
        [-1, 1,-1],
        
        [-1,-1, 0],
        [-1,-1, 1],
        [-1,-1,-1],
    ]
    
    private var cells: [CCCubeCell] = []
    
    
    
    // Extracts and returns dominant colors of the image (the array contains UIColor objects). Result might be empty.
    public func extractColors(fromImage image:UIImage, withFlags flags: [CCFlags] ) -> [UIColor] {
        // Get maxima
        let sortedMaxima = self.extractAndFilterMaxima(fromImage: image, flags: flags)
        
        // Return color array
        return self.colors(fromMaxima: sortedMaxima)
    }
    
    // Same as above but avoids colors too close to the specified one.
    // IMPORTANT: The avoidColor must be in RGB, so create it with colorWithRed method of UIColor!
    public func extractColors(fromImage image:UIImage, withFlags flags: [CCFlags], avoidColor: UIColor ) -> [UIColor] {
        // Get maxima
        var sortedMaxima = self.extractAndFilterMaxima(fromImage: image, flags: flags)
        
        // Filter out colors that are too close to the specified color
        sortedMaxima = self.filter(maxima: sortedMaxima, tooCloseToColor: avoidColor)
        
        // Return color array
        return self.colors(fromMaxima: sortedMaxima)
    }
    
    // Tries to get count bright colors from the image, avoiding the specified one (only if avoidColor is non-nil).
    // IMPORTANT: The avoidColor (if set) must be in RGB, so create it with colorWithRed method of UIColor!
    // Might return less than count colors!
    public func extractBrightColors(fromImage image: UIImage, avoidColor: UIColor?, count: Int ) -> [UIColor] {
        
        // Get maxima (bright only)
        var sortedMaxima = self.findAndSortMaxima(inImage: image, flags: [.onlyBrightColors])
        
        if let avoidColor = avoidColor {
            // Filter out colors that are too close to the specified color
            sortedMaxima = self.filter(maxima: sortedMaxima, tooCloseToColor: avoidColor)
        }
        
        // Do clever distinct color filtering
        sortedMaxima = self.performAdaptiveDistinctFiltering(forMaxima: sortedMaxima, count: count)
        
        // Return color array
        return self.colors(fromMaxima: sortedMaxima)
    }
    
    // Tries to get count dark colors from the image, avoiding the specified one (only if avoidColor is non-nil).
    // IMPORTANT: The avoidColor (if set) must be in RGB, so create it with colorWithRed method of UIColor!
    // Might return less than count colors!
    public func extractDarkColors(fromImage image: UIImage, avoidColor: UIColor, count: Int ) -> [UIColor] {
        // Get maxima (bright only)
        var sortedMaxima = self.findAndSortMaxima(inImage: image, flags: [.onlyDarkColors])
        
        // Filter out colors that are too close to the specified color
        sortedMaxima = self.filter(maxima: sortedMaxima, tooCloseToColor: avoidColor)
        
        // Do clever distinct color filtering
        sortedMaxima = self.performAdaptiveDistinctFiltering(forMaxima: sortedMaxima, count: count)
        
        // Return color array
        return self.colors(fromMaxima: sortedMaxima)
    }
    
    // Tries to get count colors from the image
    // Might return less than count colors!
    public func extractColors(fromImage image: UIImage, withFlags flags: [CCFlags],  count: Int) -> [UIColor] {
        // Get maxima
        var sortedMaxima = self.extractAndFilterMaxima(fromImage: image, flags: flags)
        
        // Do clever distinct color filtering
        sortedMaxima = self.performAdaptiveDistinctFiltering(forMaxima: sortedMaxima, count: count)
        
        // Return color array
        return self.colors(fromMaxima: sortedMaxima)
    }
    
    
    // Returns array of raw pixel data (needs to be freed)
    fileprivate func rawPixelData(fromImage image: UIImage) -> (data: [CUnsignedChar], pixelCount: Int) {
        // Get cg image and its size
        let cgImage = image.cgImage
        
        let width = cgImage?.width ?? 0
        let height = cgImage?.height ?? 0
        
        var rawData = [CUnsignedChar](repeating: 0, count: height * width * 4)
        
        // Create the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        
        let context = CGContext.init(
            data: &rawData,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        )
        
        context?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        return (data: rawData, pixelCount: width * height)
    }
    
    // Resets all cells
    fileprivate func clearCells() {
        self.cells.removeAll()
        
        self.cells = [CCCubeCell](
            repeating: CCCubeCell(),
            count: CCColorCube.COLOR_CUBE_RESOLUTION * CCColorCube.COLOR_CUBE_RESOLUTION * CCColorCube.COLOR_CUBE_RESOLUTION
        )
        
    }
    
    // private class func CELL_INDEX(r,g,b) (r+g*COLOR_CUBE_RESOLUTION+b*COLOR_CUBE_RESOLUTION*COLOR_CUBE_RESOLUTION)
    private func cellIndexFrom(r: Int, g: Int, b: Int) -> Int {
        return ( r + g * CCColorCube.COLOR_CUBE_RESOLUTION + b * CCColorCube.COLOR_CUBE_RESOLUTION * CCColorCube.COLOR_CUBE_RESOLUTION)
    }
    
    // Returns array of CCLocalMaximum objects
    fileprivate func findLocalMaxima(inImage image: UIImage, flags: [CCFlags]) -> [CCLocalMaximum] {
        self.clearCells()
        
        var raw = self.rawPixelData(fromImage: image)
        
        // TODO: raw.data can be nil
        
        // Helper variables
        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat
        
        var redIndex: Int
        var greenIndex: Int
        var blueIndex: Int
        var cellIndex: Int
        var localHitCount: Int
        
        var isLocalMaximum: Bool
        
        for k in 0...(raw.pixelCount - 1) {
            
            // Get color components as floating point value in [0,1]
            red = (CGFloat)(raw.data[k * 4 + 0]) / 255.0
            green = (CGFloat)(raw.data[k * 4 + 1]) / 255.0
            blue = (CGFloat)(raw.data[k * 4 + 2]) / 255.0
            
            // If we only want bright colors and this pixel is dark, ignore it
            if flags.contains(.onlyBrightColors) {
                if red < CCColorCube.BRIGHT_COLOR_THRESHOLD && green < CCColorCube.BRIGHT_COLOR_THRESHOLD && blue < CCColorCube.BRIGHT_COLOR_THRESHOLD {
                    continue
                }
            } else if flags.contains(.onlyDarkColors) {
                if red >= CCColorCube.BRIGHT_COLOR_THRESHOLD || green >= CCColorCube.BRIGHT_COLOR_THRESHOLD || blue >= CCColorCube.BRIGHT_COLOR_THRESHOLD {
                    continue
                }
            }
            
            // Map color components to cell indices in each color dimension
            redIndex   = (Int)(red * (CCColorCube.COLOR_CUBE_RESOLUTION_GCFLOAT - 1.0));
            greenIndex = (Int)(green*(CCColorCube.COLOR_CUBE_RESOLUTION_GCFLOAT - 1.0));
            blueIndex  = (Int)(blue*(CCColorCube.COLOR_CUBE_RESOLUTION_GCFLOAT - 1.0));
            
            // Compute linear cell index
            // cellIndex = CELL_INDEX(redIndex, greenIndex, blueIndex);
            cellIndex = cellIndexFrom(r: redIndex, g: greenIndex, b: blueIndex)
            
            
            // Increase hit count of cell
            cells[cellIndex].hitCount += 1;
            
            // Add pixel colors to cell color accumulators
            cells[cellIndex].redAcc   += red;
            cells[cellIndex].greenAcc += green;
            cells[cellIndex].blueAcc  += blue;
        }
        
        // We collect local maxima in here
        var localMaxima: [CCLocalMaximum] = []
        
        let neighbourIndices = CCColorCube.neighbourIndices
        
        // Find local maxima in the grid
        for r in 0...(CCColorCube.COLOR_CUBE_RESOLUTION - 1) {
            for g in 0...(CCColorCube.COLOR_CUBE_RESOLUTION - 1) {
                for b in 0...(CCColorCube.COLOR_CUBE_RESOLUTION - 1) {
                    
                    // Get hit count of this cell
                    localHitCount = cells[cellIndexFrom(r: r, g: g, b: b)].hitCount;
                    
                    // If this cell has no hits, ignore it (we are not interested in zero hits)
                    if localHitCount == 0 { continue }
                    
                    // It is local maximum until we find a neighbour with a higher hit count
                    isLocalMaximum = true;
                    
                    // Check if any neighbour has a higher hit count, if so, no local maxima
                    for n in 0...26 {
                        redIndex = r + neighbourIndices[n][0]
                        greenIndex = g + neighbourIndices[n][1]
                        blueIndex = b + neighbourIndices[n][2]
                        
                        // Only check valid cell indices (skip out of bounds indices)
                        if redIndex >= 0 && greenIndex >= 0 && blueIndex >= 0 {
                            if (redIndex < CCColorCube.COLOR_CUBE_RESOLUTION && greenIndex < CCColorCube.COLOR_CUBE_RESOLUTION && blueIndex < CCColorCube.COLOR_CUBE_RESOLUTION) {
                                if (cells[cellIndexFrom(r: redIndex, g: greenIndex, b: blueIndex)].hitCount > localHitCount) {
                                    // Neighbour hit count is higher, so this is NOT a local maximum.
                                    isLocalMaximum = false;
                                    // Break inner loop
                                    break;
                                }
                            }
                        }
                    }
                    
                    // If this is not a local maximum, continue with loop.
                    if !isLocalMaximum { continue }
                    
                    // Otherwise add this cell as local maximum
                    let maximum = CCLocalMaximum()
                    maximum.cellIndex = cellIndexFrom(r: r, g: g, b: b)
                    maximum.hitCount = cells[maximum.cellIndex].hitCount
                    maximum.red   = cells[maximum.cellIndex].redAcc / (CGFloat)(cells[maximum.cellIndex].hitCount)
                    maximum.green = cells[maximum.cellIndex].greenAcc / (CGFloat)(cells[maximum.cellIndex].hitCount)
                    maximum.blue  = cells[maximum.cellIndex].blueAcc / (CGFloat)(cells[maximum.cellIndex].hitCount)
                    maximum.brightness = fmax(fmax(maximum.red, maximum.green), maximum.blue)
                    localMaxima.append(maximum)
                }
            }
        }
        
        
        // Finally sort the array of local maxima by hit count
        //        let sortedMaxima = [localMaxima sortedArrayUsingComparator:^NSComparisonResult(CCLocalMaximum *m1, CCLocalMaximum *m2){
        //            if (m1.hitCount == m2.hitCount) return NSOrderedSame;
        //            return m1.hitCount > m2.hitCount ? NSOrderedAscending : NSOrderedDescending;
        //            }];
        let sortedMaxima = localMaxima.sorted { $0.hitCount > $1.hitCount }
        
        return sortedMaxima;
    }
    
    // Returns array of CCLocalMaximum objects
    fileprivate func findAndSortMaxima(inImage image: UIImage, flags: [CCFlags]) -> [CCLocalMaximum] {
        
        // First get local maxima of image
        var sortedMaxima = self.findLocalMaxima(inImage: image, flags: flags)
        
        // Filter the maxima if we want only distinct colors
        if flags.contains(.onlyDistinctColors) {
            sortedMaxima = self.filterDistinct(maxima: sortedMaxima, threshold: CCColorCube.DISTINCT_COLOR_THRESHOLD)
        }
        
        // If we should order the result array by brightness, do it
        if flags.contains(.orderByBrightness) {
            sortedMaxima = self.orderByBrightness(maxima: sortedMaxima)
        } else if flags.contains(.orderByDarkness) {
            sortedMaxima = self.orderByDarkness(maxima: sortedMaxima)
        }
        
        
        return sortedMaxima
    }
    
    // Returns array of CCLocalMaximum objects
    fileprivate func extractAndFilterMaxima(fromImage image: UIImage, flags: [CCFlags]) -> [CCLocalMaximum] {
        // Get maxima
        var sortedMaxima = self.findAndSortMaxima(inImage: image, flags: flags)
        
        // Filter out colors too close to black
        if flags.contains(.avoidBlack) {
            sortedMaxima = self.filter(maxima: sortedMaxima, tooCloseToColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1))
        }
        
        // Filter out colors too close to white
        if flags.contains(.avoidWhite) {
            sortedMaxima = self.filter(maxima: sortedMaxima, tooCloseToColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1))
        }
        
        // Return maxima array
        return sortedMaxima;
    }
    
    // Returns array of UIColor objects
    fileprivate func colors(fromMaxima maxima: [CCLocalMaximum]) -> [UIColor] {
        return maxima.map({UIColor(red: $0.red, green: $0.green, blue: $0.blue, alpha: 1) })
    }
    
    // Returns new array with only distinct maxima
    fileprivate func filterDistinct(maxima: [CCLocalMaximum], threshold: CGFloat) -> [CCLocalMaximum] {
        var filteredMaxima: [CCLocalMaximum] = [];
        
        // Check for each maximum
        for k in 0...(maxima.count - 1) {
            // Get the maximum we are checking out
            let max1 = maxima[k]
            
            // This color is distinct until a color from before is too close
            var isDistinct = true
            
            // Go through previous colors and look if any of them is too close
            
            if k > 0 {
                for n in 0...(k - 1) {
                    // Get the maximum we compare to
                    let max2 = maxima[n]
                    
                    // Compute delta components
                    let redDelta   = max1.red - max2.red
                    let greenDelta = max1.green - max2.green
                    let blueDelta  = max1.blue - max2.blue
                    
                    // Compute delta in color space distance
                    let delta = sqrt(redDelta * redDelta + greenDelta * greenDelta + blueDelta * blueDelta)
                    
                    // If too close mark as non-distinct and break inner loop
                    if delta < threshold {
                        isDistinct = false
                        break
                    }
                }
            }
            
            // Add to filtered array if is distinct
            if isDistinct {
                filteredMaxima.append(max1)
            }
        }
        
        return filteredMaxima;
    }
    
    // Removes maxima too close to specified color
    fileprivate func filter(maxima: [CCLocalMaximum], tooCloseToColor color: UIColor) -> [CCLocalMaximum] {
        // Get color components
        let components = color.cgColor.components ?? []
        
        var filteredMaxima: [CCLocalMaximum] = []
        
        // Check for each maximum
        for k in 0...(maxima.count - 1) {
            // Get the maximum we are checking out
            let max1 = maxima[k]
            
            // Compute delta components
            let redDelta   = max1.red - components[0]
            let greenDelta = max1.green - components[1]
            let blueDelta  = max1.blue - components[2]
            
            // Compute delta in color space distance
            let delta = sqrt(redDelta*redDelta + greenDelta*greenDelta + blueDelta*blueDelta)
            
            // If not too close add it
            if delta >= 0.5 {
                filteredMaxima.append(max1)
            }
        }
        
        return filteredMaxima
    }
    
    // Tries to get count distinct maxima
    fileprivate func performAdaptiveDistinctFiltering(forMaxima maxima: [CCLocalMaximum], count: Int) -> [CCLocalMaximum] {
        
        var maxima = maxima
        
        // If the count of maxima is higher than the requested count, perform distinct thresholding
        if maxima.count > count {
            
            var tempDistinctMaxima = maxima
            var distinctThreshold: CGFloat = 0.1
            
            // Decrease the threshold ten times. If this does not result in the wanted count
            for _ in 0...9 {
                // Get array with current distinct threshold
                tempDistinctMaxima = self.filterDistinct(maxima: maxima, threshold: distinctThreshold)
                
                // If this array has less than count, break and take the current sortedMaxima
                if tempDistinctMaxima.count <= count {
                    break;
                }
                
                // Keep this result (length is > count)
                maxima = tempDistinctMaxima;
                
                // Increase threshold by 0.05
                distinctThreshold += 0.05;
            }
            
            // Only take first count maxima
            maxima = Array(maxima.prefix(count))
        }
        
        return maxima;
        
    }
    
    // Orders maxima by brightness
    fileprivate func orderByBrightness(maxima: [CCLocalMaximum]) -> [CCLocalMaximum] {
        return maxima.sorted(by: { $0.brightness > $1.brightness })
    }
    
    // Orders maxima by darkness
    fileprivate func orderByDarkness(maxima: [CCLocalMaximum]) -> [CCLocalMaximum] {
        return maxima.sorted(by: { $0.brightness < $1.brightness })
    }
}
