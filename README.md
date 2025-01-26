
# ChatGPT

## Getting Started

Follow the steps below to set up the project locally.

### Prerequisites

- [Firebase Console](https://firebase.google.com/)
- [Cloudinary Account](https://cloudinary.com/)
- [OpenAI API Key](https://platform.openai.com/)
- MongoDB Connection URL

### Steps to Clone and Setup

1. **Clone the Repository**  
   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```

2. **Initialize Firebase**  
   - Go to your Firebase console and set up a new project.  
   - Download the `google-services.json` file and place it in the `/android/app/` directory.


3. **Initialize Cloudinary**  
   - Log in to your Cloudinary dashboard.  
   - Retrieve your **Cloud Name** and **Upload Preset** values.  
   - Add them to the `.env` file.

4. **Get OpenAI API Key**  
   - Sign up or log in to [OpenAI](https://platform.openai.com/).  
   - Generate your API key and update it in the `.env` file.
  

5. **Set Up Environment Variables**  
   - Copy the example environment file:  
     ```bash
     cp .env.example .env
     ```
   - Open the `.env` file and update the following details:  
     ```env
     DATABASE_URL="<your_mongoDB_connection_url>"
     USER_COLLECTION="<userCollection_db_name>"
     CHAT_COLLECTION="<chatsCollection_db_name>"
     API_KEY="<your_openai_API_key>"
     CLOUD_NAME="<your_cloudinary_cloud_name>"
     UPLOAD_PRESET="<your_upload_preset_name>"
     ```

### Run the Project

1. Install dependencies:  
   ```bash
   flutter pub get
   ```

2. Run the project:  
   ```bash
   flutter run
   ```

---

Let me know if you'd like to add more details, such as troubleshooting or contribution guidelines!
