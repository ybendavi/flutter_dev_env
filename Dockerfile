# Utiliser une image de base légère
FROM debian:bullseye-slim

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    xz-utils \
    libglu1-mesa \
    openjdk-11-jdk-headless \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    && rm -rf /var/lib/apt/lists/*

# Installer Flutter (en tant que root)
RUN git clone https://github.com/flutter/flutter.git /flutter

# Changer les permissions pour permettre à l'utilisateur non-root d'accéder au dossier Flutter
RUN chown -R 1000:1000 /flutter

# Ajouter un utilisateur non-root
RUN useradd -m -u 1000 -s /bin/bash flutteruser

# Passer à l'utilisateur non-root
USER flutteruser
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:$PATH"

# Précharger les dépendances Flutter
RUN flutter doctor -v
RUN flutter precache

# Installer les licences Android SDK (optionnel, nécessaire pour Android)
RUN yes | flutter doctor --android-licenses

# Ajouter l'installation de l'Android SDK et les outils
USER root
RUN mkdir -p /android-sdk/cmdline-tools \
    && curl -o sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip \
    && unzip sdk-tools.zip -d /android-sdk/cmdline-tools \
    && mv /android-sdk/cmdline-tools/cmdline-tools /android-sdk/cmdline-tools/latest \
    && rm sdk-tools.zip

ENV ANDROID_HOME=/android-sdk
ENV PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH

# Accepter les licences Android SDK
RUN yes | sdkmanager --licenses
RUN sdkmanager "platform-tools" "platforms;android-33" "build-tools;30.0.3"

# Revenir à l'utilisateur non-root
USER flutteruser

# Définir le répertoire de travail pour le projet
WORKDIR /home/flutteruser/app

# Commande par défaut
CMD ["bash"]

#Commande pour ouvrir un serveur web : flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0

