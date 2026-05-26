# My Supabase App

A Project that demonstrates a complete real-world integration with [Supabase](https://supabase.com/). This project showcases Authentication, Real-time Chat, CRUD operations, and File Storage.
Created as a part of my learning journey in Supabase.

## 🚀 Features

### 🔐 Authentication

- User registration and login flow using Supabase Auth.
- Maintains user session state securely.

### 💬 Real-time Chat

- **Direct Messages (DMs):** One-on-one chat functionality.
- **Group Chats:** Create groups with multiple members.
- **Real-time Updates:** Instant message delivery and read updates using Supabase Realtime Channels.
- **User Search:** Find and start chatting with other users by username.

### 📝 Notes Management (CRUD)

- Create, Read, Update, and Delete personalized notes.
- Real-time synchronization of notes on the Home Dashboard.

### 📁 File Storage & Gallery

- Upload images/files securely to Supabase Storage.
- Dedicated Gallery view to manage and delete uploaded files.
- Generates secure signed URLs for file access.

## 🛠 Tech Stack

- **Framework:** [Flutter](https://flutter.dev/)
- **Backend:** [Supabase](https://supabase.com/) (`supabase_flutter`)
- **State Management:** Provider (`provider`)
- **Environment Config:** `flutter_dotenv`

## 📂 Project Structure

- `lib/core/` - Core logic and state management providers (`ChatProvider`, `ClientProvider`).
- `lib/helpers/` - Utility methods (e.g., Note helpers).
- `lib/model/` - Data models (e.g., `Note`).
- `lib/presentation/` - UI layer containing `pages` and reusable `widgets`.
- `lib/service/` - Supabase service integrations (`FileStorageService`, `NoteDatabaseService`).

## ⚙️ Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
- A [Supabase](https://supabase.com/) project setup with Authentication, Database, and Storage configured.

### Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/apollocked/supabase_app
    ```

2.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Setup Environment Variables:**
    Create a `.env` file in the root directory and add your Supabase credentials:

    ```env
    SUPABASE_URL=your_supabase_project_url
    SUPABASE_ANON_KEY=your_supabase_anon_key
    ```

4.  **Run the application:**
    ```bash
    flutter run
    ```
