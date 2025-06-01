#!/bin/bash

# Menu principal

clear
echo "==============================================="
echo "🎩 FEDORA TURBO"
echo "📦 Automatizando o seu ambiente"
echo "🐧 Por ThalisVN"
echo "==============================================="
echo ""
echo "Escolha o perfil de instalação:"
echo "1 - Instalação completa (pessoal + profissional)"
echo "2 - Uso pessoal (apps do dia a dia)"
echo "3 - Uso profissional (dev, produtividade)"
echo "0 - Sair"
echo ""
read -p "Digite sua escolha: " opcao

# Funções

preparar_base() {
    echo "🔧 Preparando sistema..."

    sudo dnf update -y

    echo "📦 Ativando RPM Fusion..."
    sudo dnf install -y \
      https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
      https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

    echo "📦 Instalando Flatpak e ativando Flathub..."
    sudo dnf install -y flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

instalar_pessoal() {
    echo "🎮 Instalando apps de uso pessoal..."

    echo "🎮 Instalando Steam via RPM Fusion..."
    sudo dnf install -y steam

    echo "💬 Instalando Discord via Flatpak..."
    flatpak install -y flathub com.discordapp.Discord

    echo "🕹️ Instalando Fightcade..."
    mkdir -p ~/Games/Fightcade
    cd ~/Games/Fightcade || exit
    wget https://github.com/fightcade/fightcade/releases/latest/download/fightcade-linux.zip
    unzip fightcade-linux.zip
    rm fightcade-linux.zip
    chmod +x fightcade
    echo "✅ Fightcade instalado em ~/Games/Fightcade"

    echo "✅ Aplicativos pessoais instalados com sucesso!"
}

instalar_profissional() {
    echo "💼 Instalando ferramentas para o uso profissional..."
    
     echo "🗑️ Removendo Firefox..."
    sudo dnf remove -y firefox

    echo "🌐 Instalando Opera via Flatpak..."
    flatpak install -y flathub com.opera.Opera

    echo "🟦 Instalando Visual Studio Code (RPM)..."
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo dnf install -y code

    echo "📦 Instalando Google git..."
    sudo dnf install -y git

    echo "📦 Instalando Postman via Flatpak..."
    flatpak install -y flathub com.getpostman.Postman

    echo "📦 Instalando MongoDB Compass via Flatpak..."
    flatpak install -y io.github.mongodb.Compass

    echo "🐬 Instalando MySQL Server..."
    sudo dnf install -y community-mysql-server
    sudo systemctl enable mysqld
    sudo systemctl start mysqld
    echo "✅ MySQL instalado e iniciado."

    echo "🐳 Instalando Docker..."
    sudo dnf install -y dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
    echo "⚠️ Você precisará reiniciar a sessão para usar Docker sem sudo."

    echo "🧹 Removendo LibreOffice..."
    sudo dnf remove -y libreoffice\*

    echo "📝 Instalando OnlyOffice via Flatpak..."
    flatpak install -y org.onlyoffice.desktopeditors

    echo "📝 Instalando Obisidian via Flatpak..."
    flatpak install -y flathub md.obsidian.Obsidian
}

instalar_completo() {
    echo "🚀 Instalando apps de uso pessoal e profissional..."
    instalar_pessoal
    instalar_profissional
}


case $opcao in
    1)
        echo "⚙️ Iniciando instalação completa..."
        preparar_base
        instalar_completo
        ;;
    2)
        echo "⚙️ Iniciando instalação para uso pessoal..."
        preparar_base
        instalar_pessoal
        ;;
    3)
        echo "⚙️ Iniciando instalação para uso profissional..."
        preparar_base
        instalar_profissional
        ;;
    0)
        echo "Saindo..."
        exit 0
        ;;
    *)
        echo "Opção inválida"
        ;;
esac

echo "==============================================="
echo "🎉 Instalação concluida com sucesso!"
echo "==============================================="
