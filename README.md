# Futoria 🚀
> **AI-Powered Career & Academic Mentor**

Futoria is a premium personal career mentor designed specifically for higher education students in India. Whether a student is pursuing a **B.Tech**, **Polytechnic (Diploma)**, or standard **Undergraduate Degree** (such as BCA, BSc, BBA, BCom, or BSc Biotechnology), Futoria builds a customized multi-year milestone roadmap tailored to their specific stream, age, and placement goals.

---

## 🎯 1. Project Domain & Problem Statement

### The Problem in Indian Higher Education
- **Lack of Directed Mentorship**: Over 90% of students in Indian colleges lack personalized guidance to transition from academic learning to placement-ready profiles.
- **Course & Level Diversity**: Standard platform templates focus heavily on B.Tech, neglecting Polytechnic (Diploma) and other general undergraduate degrees (BCA, BSc, BBA, BCom).
- **Milestone Gaps**: Students often don't know what skills, certifications, and projects they need to complete year-by-year, leading to placement rejections.
- **Interview/Exam Unpreparedness**: Accessing realistic, company-specific interview reviews and exam preparation guides is fragmented.

### The Solution: Futoria
Futoria provides an all-in-one AI career co-pilot that:
1. Conducts an initial interactive **interest-assessment onboarding questionnaire**.
2. Automatically generates **dynamic 3-year timelines (for Polytechnic/Degree)** or **4-year timelines (for B.Tech)**.
3. Offers a **Conversational AI Mentor** powered by **Groq Llama 3** for instant career, tutorial, and branch comparison chats.
4. Includes an **Academic Tracker** with regulation schemas and prep guidelines.
5. Provides **Verified Company Q&A Reviews** (40+ companies) directly in the footer navbar.

---

## 🛠️ 2. Core Features Built

### 🤖 Interactive Onboarding & Assessment
- Collects name, age, course level (`B.Tech`, `Polytechnic`, `Degree`), stream/branch, and inter-passing year.
- Calculates an initial career score using a slide assessment.

### 📅 Dynamic Milestone Semester Planner
- Adapts to program lengths dynamically: **3 Years (6 Semesters)** for general degrees and diplomas; **4 Years (8 Semesters)** for B.Tech.
- Loaded with stream-specific milestones (CSE, ECE, EEE, Mechanical, Civil, Chemical, BCA, BBA, BCom, Biotechnology, and Automobile).

### 📈 Career & Branch Comparison Simulators
- Allows students to simulate salary potentials, placement realities, and compare two engineering or degree streams side-by-side.

### 💬 Groq Llama 3 AI Mentor & Video Tutorials
- High-speed conversational mentor.
- Integrates with the **YouTube Data API** to recommend video tutorials for the searched topic dynamically (e.g. C, Python, VLSI, EV, etc.).

### 📝 40+ Verified Top-Company Reviews
- Flat JSON database loaded with real questions, answers, and batch-wise requirements from companies like Microsoft, Amazon, TCS, Infosys, and more.

### 🌎 Localized UI Theme
- Support for **English, Hindi, Telugu, and Tamil** language localization.

---

## 💻 3. Technology Stack
- **Framework**: [Flutter](https://flutter.dev) (iOS, Android, and Web)
- **Database / Auth**: [Cloud Firestore](https://firebase.google.com/docs/firestore) & [Firebase Auth](https://firebase.google.com/docs/auth)
- **LLM AI Service**: [Groq API (Llama 3)](https://groq.com)
- **Video Recommendations**: [YouTube Data API v3](https://developers.google.com/youtube/v3)
- **State Management**: [Provider](https://pub.dev/packages/provider)

---

## ⚙️ 4. Local Installation Guide

### Prerequisites
- Flutter SDK installed (`>=3.0.0`)
- Firebase Account & Google Services configurations

### Setup
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd futoria
   ```
2. Create a `.env` file in the root directory:
   ```env
   GROQ_API_KEY=your_groq_api_key_here
   YOUTUBE_API_KEY=your_youtube_api_key_here
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run
   ```

---

## 🌐 5. How to Deploy the Web Version Live (Hosting Guide)

To submit a live URL to Google Forms or GitHub, you can host the Flutter Web build. Here are the three best hosting pathways:

### Option A: Firebase Hosting (Recommended)
Since the app already runs on Firebase, you can initialize and deploy hosting:
1. Install Firebase CLI and login:
   ```bash
   npm install -g firebase-tools
   firebase login
   ```
2. Build the Flutter Web release version:
   ```bash
   flutter build web --release
   ```
3. Initialize Firebase Hosting in the folder:
   ```bash
   firebase init hosting
   ```
   - *Select active project*: `future-pathai`
   - *What do you want to use as your public directory?* Enter `build/web`
   - *Configure as a single-page app?* Enter `Yes`
4. Deploy rules, indexes, and web files live:
   ```bash
   firebase deploy
   ```

### Option B: GitHub Pages
1. Build the Flutter Web project:
   ```bash
   flutter build web --release
   ```
2. Use the `gh-pages` package to publish directly:
   ```bash
   npm install -g gh-pages
   gh-pages -d build/web
   ```

### Option C: Vercel Hosting
1. Install Vercel CLI:
   ```bash
   npm install -g vercel
   ```
2. Build web release:
   ```bash
   flutter build web --release
   ```
3. Deploy the `build/web` folder:
   ```bash
   cd build/web
   vercel deploy --prod
   ```

---

## 📝 6. Google Forms Submission Checklist
When submitting the project, make sure to include:
- **GitHub Repository URL**: Containing clean directories, Firestore rules, and this rebranded `README.md`.
- **Live Web App URL**: Hosted on Firebase Hosting or Vercel (e.g. `https://future-pathai.web.app` or similar).
- **Demo Credentials**: Add dummy details (email: `demo@futoria.ai` / password) if required for review.
