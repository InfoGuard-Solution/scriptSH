#!/bin/bash

echo "Olá, bem-vindo(a) ao Super Vision!"
echo "Por favor, escolha uma opção:"
echo "1. Atualizar bibliotecas"
echo "2. Verificar e instalar/atualizar Java e instalar .jar"
echo "3. Instalar SQL"
echo "4. Sair"

read -p "Digite o número da opção desejada: " choice

case $choice in
    1)
        echo "Atualizando bibliotecas..."
        sudo apt update -y
        sudo apt upgrade -y
        ;;
    2)
        echo "Verificando instalação do Java..."
        java -version

        if [ $? = 0 ]; then
            echo "Você já tem o Java instalado. Gostaria de atualizá-lo? [s/n]"
            read update_java

            if [ "$update_java" == "s" ]; then
                sudo apt install openjdk-17-jdk -y
                sudo apt install openjdk-17-jre -y
            fi
        else
            echo "Java não instalado. Gostaria de instalá-lo? [s/n]"
            read install_java

            if [ "$install_java" == "s" ]; then
                sudo apt install openjdk-17-jdk -y
                sudo apt install openjdk-17-jre -y
            fi
        fi

        echo "Gostaria de baixar e executar o projeto .jar neste momento? [s/n]"
        read install_jar

        if [ "$install_jar" == "s" ]; then
            git clone 'https://github.com/winycios/desafioSO.git'
            sleep 2
            cd 'desafioSO'
            mv prototipo-inovacao.jar ..
            cd ..
            rm -rf desafioSO
            chmod +x prototipo-inovacao.jar
            java -jar 'prototipo-inovacao.jar'
            echo -e "Projeto executado com sucesso"
        fi
        ;;
    3)
        echo "Instalando SQL..."
	
	mkdir docker	
	cd ./docker
	
	git clone -b contigencia https://github.com/InfoGuard-Solution/banco-de-dados-supervisiOn.git

	sudo apt install docker.io -y
	sudo systemctl start docker
	sudo systemctl enable docker

	sudo tee Dockerfile <<EOF
FROM mysql:latest
ENV MYSQL_ROOT_PASSWORD=superOn
COPY ./banco-de-dados-supervisiOn/ /docker-entrypoint-initdb.d/
EXPOSE 3306
EOF

	
	sudo docker build -t banco-teste .
	sudo docker run -d --name meu-container -p 3306:3306 banco-teste

	sudo docker ps -a

	echo "Instalado com sucesso"
	
        ;;
    4)
        echo "Saindo..."
        exit 0
        ;;
    *)
        echo "Opção inválida. Por favor, escolha uma opção válida."
        ;;
esac
