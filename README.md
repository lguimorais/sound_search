# 🎵 SoundSearch

> Aplicativo de descoberta musical desenvolvido para a rádio comunitária universitária do ICEV — Teresina/PI.  
> Permite buscar músicas, ouvir previews de 30 segundos e salvar uma playlist pessoal de sugestões para a programação.


## 🎯 Sobre o Projeto

A rádio recebia muitos pedidos repetidos porque os ouvintes não conheciam artistas novos. Quando tentavam explorar, se perdiam em plataformas como Spotify que exigem conta e são complexas demais para uma busca rápida.

O **SoundSearch** resolve isso com uma ferramenta simples e direta:

- 🔍 Busca por músicas, álbuns ou artistas
- 🎧 Preview de 30 segundos antes de sugerir
- 📋 Playlist pessoal salva no dispositivo
- 📻 Flag "Sugerir para a rádio" para facilitar pedidos

---

## 🚀 Como Executar o Projeto

### Pré-requisitos

Certifique-se de ter instalado:

| Ferramenta | Versão mínima | Link |
|---|---|---|
| Flutter SDK | 3.0.0 | [flutter.dev](https://flutter.dev/docs/get-started/install) |
| Dart SDK | 3.0.0 | Incluído no Flutter |
| Android Studio | Qualquer | Para o emulador Android |
| Git | Qualquer | Para clonar o repositório |

Verifique se o ambiente está correto:

```bash
flutter doctor
```

Todos os itens devem aparecer com ✅. Se algum estiver com ❌, siga as instruções do próprio comando.

---

### 1. Clonar o repositório

```bash
git clone https://github.com/seu-usuario/sound_search.git
cd sound_search
```

---

### 2. Instalar as dependências

```bash
flutter pub get
```

---

### 3. Configurar permissões (já incluídas no projeto)

**Android** — `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

**iOS** — `ios/Runner/Info.plist`:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

---

### 4. Conectar um dispositivo ou iniciar emulador

**Dispositivo físico Android:**
- Ative o Modo Desenvolvedor no celular
- Ative a Depuração USB
- Conecte via USB

**Emulador Android:**
```bash
# Listar emuladores disponíveis
flutter emulators

# Iniciar um emulador
flutter emulators --launch <nome_do_emulador>
```

Verifique se o dispositivo foi reconhecido:
```bash
flutter devices
```

---

### 5. Executar o app

```bash
# Modo debug (com hot reload)
flutter run

# Modo release (mais performático)
flutter run --release
```

---

### 6. Gerar APK para Android

```bash
# APK de debug
flutter build apk --debug

# APK de release (para distribuição)
flutter build apk --release
```

O APK gerado estará em:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 🏗️ Arquitetura

O projeto segue a **Clean Architecture** dividida em 3 camadas independentes:

```
┌─────────────────────────────────────────────────────┐
│                 PRESENTATION LAYER                  │
│         Screens │ Widgets │ Providers (Estado)      │
├─────────────────────────────────────────────────────┤
│                   DOMAIN LAYER                      │
│          Entities │ Use Cases │ Interfaces          │
├─────────────────────────────────────────────────────┤
│                    DATA LAYER                       │
│       Models │ DataSources │ Repositories Impl.     │
└─────────────────────────────────────────────────────┘
          ↕ iTunes API    ↕ SQLite    ↕ SharedPrefs
```

### Por que Clean Architecture?

- Cada camada tem **uma única responsabilidade**
- A UI **não conhece** os detalhes da API
- Mudanças na API **não quebram** a lógica de negócio
- Facilita **testes unitários** isolados

---

## 📁 Estrutura de Pastas

```
lib/
├── main.dart                          ← Ponto de entrada + navegação principal
│
├── core/                              ← Utilitários globais
│   ├── constants/
│   │   ├── api_constants.dart         ← URL base e parâmetros da API
│   │   ├── app_colors.dart            ← Paleta de cores do app
│   │   ├── app_strings.dart           ← Textos e labels centralizados
│   │   └── app_routes.dart            ← Rotas nomeadas
│   └── errors/
│       └── failures.dart              ← Classes de erros customizados
│
├── data/                              ← Camada de Dados
│   ├── datasources/
│   │   ├── itunes_remote_datasource.dart  ← Consome a iTunes Search API
│   │   └── playlist_local_datasource.dart ← SQLite (DatabaseHelper)
│   ├── models/
│   │   └── track_model.dart           ← JSON ↔ Objeto Dart ↔ SQLite
│   └── repositories/
│       └── music_repository_impl.dart ← Implementação do repositório
│
├── domain/                            ← Camada de Domínio (regras de negócio)
│   ├── entities/
│   │   └── track.dart                 ← Entidade pura (sem JSON, sem banco)
│   ├── repositories/
│   │   └── music_repository.dart      ← Interface (contrato)
│   └── usecases/
│       ├── search_tracks_usecase.dart ← Buscar músicas
│       ├── save_track_usecase.dart    ← Salvar na playlist
│       ├── get_playlist_usecase.dart  ← Carregar playlist
│       └── delete_track_usecase.dart  ← Remover da playlist
│
├── presentation/                      ← Camada de Apresentação
│   ├── providers/
│   │   ├── search_provider.dart       ← Estado da busca (ViewModel)
│   │   └── playlist_provider.dart     ← Estado da playlist (ViewModel)
│   ├── screens/
│   │   ├── splash_screen.dart         ← Tela de carregamento animada
│   │   ├── search_screen.dart         ← Tela 1: Busca
│   │   ├── detail_screen.dart         ← Tela 2: Detalhes da música
│   │   └── playlist_screen.dart       ← Tela 3: Playlist pessoal
│   └── widgets/
│       ├── track_card.dart            ← Card de resultado de busca
│       ├── playlist_card.dart         ← Card da playlist
│       ├── search_bar_widget.dart     ← Barra de busca + filtros
│       ├── audio_player_widget.dart   ← Player de áudio (preview 30s)
│       └── loading_widget.dart        ← Indicador de carregamento
│
└── assets/
    └── images/
        └── logo.jpg                   ← Logo do app
```

---

## 🛠️ Tecnologias e Pacotes

### Framework

| Tecnologia | Versão | Uso |
|---|---|---|
| **Flutter** | ^3.0.0 | Framework principal — UI multiplataforma |
| **Dart** | ^3.0.0 | Linguagem de programação |

### Pacotes de Produção

| Pacote | Versão | Finalidade |
|---|---|---|
| **provider** | ^6.1.1 | Gerenciamento de estado (ChangeNotifier + Consumer) |
| **http** | ^1.2.1 | Requisições HTTP para a iTunes Search API |
| **sqflite** | ^2.3.2 | Banco de dados SQLite local (playlist persistente) |
| **path** | ^1.9.0 | Construção de caminhos de arquivo seguros (usado com sqflite) |
| **shared_preferences** | ^2.2.2 | Armazenamento de preferências simples (tipo de busca padrão) |
| **just_audio** | ^0.9.36 | Reprodução do preview de áudio de 30 segundos |

### Pacotes de Desenvolvimento

| Pacote | Versão | Finalidade |
|---|---|---|
| **flutter_launcher_icons** | ^0.13.1 | Geração automática do ícone do app para Android/iOS |
| **flutter_lints** | ^3.0.0 | Regras de lint para código limpo |

### API Externa

| API | Autenticação | Documentação |
|---|---|---|
| **iTunes Search API** | Gratuita, sem chave | [developer.apple.com](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/) |

---

## 🎨 Padrões de Projeto Utilizados

| Padrão | Onde é aplicado |
|---|---|
| **Clean Architecture** | Separação em Data / Domain / Presentation |
| **Repository Pattern** | `MusicRepository` (interface) + `MusicRepositoryImpl` |
| **MVVM** | `SearchProvider` e `PlaylistProvider` como ViewModels |
| **Dependency Injection** | Dependências injetadas via construtor em todas as camadas |
| **Singleton** | `DatabaseHelper.instance` — única instância do banco |
| **Factory Constructor** | `TrackModel.fromJson()` e `TrackModel.fromMap()` |
| **Use Case** | Uma classe por ação de negócio (`SearchTracksUseCase` etc.) |
| **Observer** | `ChangeNotifier` + `notifyListeners()` notifica a UI |

---

## 📡 Integração com a iTunes Search API

### Como funciona

A API da Apple é consultada via HTTP GET sem necessidade de autenticação:

```
GET https://itunes.apple.com/search
  ?term=Beatles
  &entity=song
  &country=BR
  &limit=20
  &explicit=No    (opcional)
```

### Parâmetros suportados

| Parâmetro | Valores possíveis | Descrição |
|---|---|---|
| `term` | qualquer texto | O que será buscado |
| `entity` | `song`, `album`, `musicArtist` | Tipo de resultado |
| `country` | `BR`, `US`, etc. | Prioridade regional |
| `limit` | 1–200 | Quantidade de resultados |
| `explicit` | `Yes`, `No` | Filtro de conteúdo explícito |

### Campos retornados (usados no app)

| Campo da API | Campo no TrackModel | Tipo |
|---|---|---|
| `trackId` | `trackId` | `int` |
| `trackName` | `trackName` | `String` |
| `artistName` | `artistName` | `String` |
| `collectionName` | `collectionName` | `String` |
| `artworkUrl100` | `artworkUrl` (→ 300x300) | `String` |
| `previewUrl` | `previewUrl` | `String?` |
| `primaryGenreName` | `genre` | `String` |
| `trackTimeMillis` | `trackTimeMillis` | `int` |
| `trackPrice` | `trackPrice` | `double` |
| `trackExplicitness` | `isExplicit` | `bool` |

### Limitações

- ⏱️ Preview máximo de **30 segundos** por faixa
- 🔒 Sem acesso à música completa (requer Apple Music API paga)
- ⚡ Rate limit: muitas buscas em sequência podem retornar dados incompletos temporariamente. Aguarde alguns minutos e o acesso é restaurado automaticamente.

---

## 💾 Armazenamento Local

### SQLite — Playlist pessoal

Tabela `playlist` criada automaticamente na primeira execução:

```sql
CREATE TABLE playlist (
  trackId         INTEGER PRIMARY KEY,
  trackName       TEXT    NOT NULL,
  artistName      TEXT    NOT NULL,
  collectionName  TEXT    NOT NULL,
  artworkUrl      TEXT    NOT NULL,
  previewUrl      TEXT,
  genre           TEXT    NOT NULL,
  trackTimeMillis INTEGER NOT NULL,
  trackPrice      REAL    NOT NULL,
  isExplicit      INTEGER NOT NULL DEFAULT 0,
  suggestToRadio  INTEGER NOT NULL DEFAULT 0
)
```

> `isExplicit` e `suggestToRadio` são `INTEGER` (0 ou 1) porque o SQLite não tem tipo booleano nativo.

### SharedPreferences — Preferências do usuário

| Chave | Tipo | Descrição |
|---|---|---|
| `searchType` | `int` | Índice do enum `SearchType` (0=song, 1=album, 2=artist) |

---

## 🖥️ Telas do Aplicativo

### Splash Screen
- Logo animado com efeito de escala + fade
- Nome do app e subtítulo
- Transição suave para a tela principal após 2.5 segundos

### Tela de Busca
- Campo de busca em destaque
- Filtros por tipo: Música / Álbum / Artista
- Switch para ocultar conteúdo explícito
- Lista de resultados com capa, nome, artista e botão play
- Estados: vazio / carregando / resultados / erro

### Tela de Detalhes
- Capa do álbum em tela cheia com gradiente
- Informações: artista, álbum, gênero, duração, preço
- Player de preview de 30 segundos com play/pause e barra de progresso
- Checkbox "Sugerir para a rádio"
- Botão salvar / remover da playlist

### Tela de Playlist Pessoal
- Lista de músicas salvas
- Badge de sugestões para a rádio
- Swipe para deletar
- Navegação para detalhes de qualquer música salva

---

## 🔄 Fluxo de Dados

```
Usuário digita → SearchProvider.search()
                      ↓
              SearchTracksUseCase.call()
                      ↓
          MusicRepositoryImpl.searchTracks()
                      ↓
      ItunesRemoteDataSourceImpl.searchTracks()
                      ↓
            http.get(iTunes API)
                      ↓
          TrackModel.fromJson(jsonDecode)
                      ↓
         SearchProvider notifyListeners()
                      ↓
          Consumer<SearchProvider> → UI
```

---

## ✅ Requisitos do Projeto Atendidos

| Requisito | Status |
|---|---|
| Campo de busca em destaque | ✅ |
| Radio buttons: música / álbum / artista | ✅ |
| Switch para filtro de conteúdo explícito | ✅ |
| Checkbox "Sugerir para a rádio" | ✅ |
| ListView com tratamento assíncrono (Future) | ✅ |
| Indicador de carregamento | ✅ |
| Tratamento de erros (sem resultado / sem conexão) | ✅ |
| Tela de detalhes com passagem de dados | ✅ |
| Armazenamento SQLite da playlist | ✅ |
| SharedPreferences para preferência de busca | ✅ |
| Preview de áudio de 30s com play/pause | ✅ (diferencial) |
| Indicador de progresso do áudio | ✅ (diferencial) |
| Layout responsivo | ✅ |
| Splash screen personalizada | ✅ (extra) |
| Ícone do app personalizado | ✅ (extra) |

---

## 👨‍💻 Desenvolvedores

- **Nome:** Luis guilherme de Morais Abreu
- **Nome:** Thiago emanuel Jorge de Sá
- **Nome:** Aline Dias Marques Ramos
- **Nome:** Joao matheus Brito
- **Curso:** Engenharia de Software
- **Instituição:** Instituto de Ensino Superior ICEV  
- **Período:** 2026

---

## 📄 Licença

Este projeto foi desenvolvido para fins acadêmicos no Instituto de Ensino Superior ICEV.

---

*Desenvolvido com 💜 e Flutter*
