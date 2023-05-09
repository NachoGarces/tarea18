require "uri"
require "net/http"
require "json"

def request(url_nasa) # Lectura de link
    url = URI(url_nasa)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    response = https.request(request)
    return JSON.parse(response.body)
end

def buid_web_page(photos) # Armado del archivo HTML
    html = "<!DOCTYPE html>
<html lang=\"es\">
    <head>
        <meta charset=\"UTF-8\">
        <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
        <title>Rover</title>
    </head>
    <body>
        <ul>
"

    photos.each do |photo|
        html += "            <li><img src=\"#{photo["img_src"]}\"></li>\n"
    end

    html += "        </ul>
    </body>
</html>"

    File.write("index.html", html)
    puts 'Archivo creado!'
end

def photos_count(infos) # reciba el hash de respuesta y devuelva un nuevo hash con el nombre de la cámara y la cantidad de fotos
    hash_cam = {}
    i = 1
    puts 'Hash de camaras con conteo de fotos'

    infos.each do |info|
        cam = info["camera"]["name"]
        
        if hash_cam.key?(:"#{cam}")
            hash_cam[:"#{cam}"] = i
            i += 1
        else
            hash_cam[:"#{cam}"] = 1
            i = 2
        end
    end
    puts hash_cam.to_s
end

data = request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=sKqFaytLvV2UnKKpZtnzmd2tEikKiNBIVRishKIv')["photos"]

buid_web_page(data)

photos_count(data)
