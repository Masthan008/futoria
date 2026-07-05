import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {

  // Branch-specific Milestone Databases
  static final Map<String, Map<int, List<Map<String, dynamic>>>> _branchMilestones = {
    'CSE': {
      1: [
        {'id': 'cse_y1_1', 'title': 'Master Programming Foundations (Python & C)', 'desc': 'Understand variables, control flows, functions, and memory management.'},
        {'id': 'cse_y1_2', 'title': 'Discrete Mathematics & Logic', 'desc': 'Study set theory, Boolean algebra, logic gates, and graph theory basics.'},
        {'id': 'cse_y1_3', 'title': 'Git & GitHub Setup', 'desc': 'Build your GitHub profile, push 5+ repositories, and learn commit workflows.'},
        {'id': 'cse_y1_4', 'title': 'AI Developer Tools Mastery', 'desc': 'Incorporate Groq, GitHub Copilot, and LLMs for code documentation.'},
        {'id': 'cse_y1_5', 'title': 'Basic Web Development (HTML/CSS/JS)', 'desc': 'Build responsive personal portfolio site and host on GitHub Pages.'},
        {'id': 'cse_y1_6', 'title': 'Communication & Technical Writing', 'desc': 'Participate in college coding clubs and write technical blogs.'},
      ],
      2: [
        {'id': 'cse_y2_1', 'title': 'Data Structures & Algorithms (DSA)', 'desc': 'Master Arrays, Linked Lists, Stacks, Queues, Trees, Graphs, and Dynamic Programming.'},
        {'id': 'cse_y2_2', 'title': 'Database Management Systems (DBMS)', 'desc': 'Learn Relational Algebra, SQL queries, Indexing, Normalization, and MongoDB.'},
        {'id': 'cse_y2_3', 'title': 'Object-Oriented Programming (Java/C++)', 'desc': 'Master Inheritance, Polymorphism, Encapsulation, and Design Patterns.'},
        {'id': 'cse_y2_4', 'title': 'Solve 150+ LeetCode / HackerRank Problems', 'desc': 'Build strong algorithmic problem-solving speed for campus screenings.'},
        {'id': 'cse_y2_5', 'title': 'Operating Systems & Linux CLI', 'desc': 'Understand Processes, Threads, Memory Management, Shell Scripting, and Bash.'},
        {'id': 'cse_y2_6', 'title': 'Build a Full-Stack CRUD Application', 'desc': 'Create a project using Flutter/React + Node.js/Python backend with database.'},
      ],
      3: [
        {'id': 'cse_y3_1', 'title': 'Computer Networks & Security', 'desc': 'Study OSI Model, TCP/IP, Sockets, HTTP/HTTPS, and basic Cryptography.'},
        {'id': 'cse_y3_2', 'title': 'Machine Learning & AI Foundations', 'desc': 'Learn Regression, Classification, Neural Networks, PyTorch/Scikit-learn, and Groq API.'},
        {'id': 'cse_y3_3', 'title': 'System Design Fundamentals (LLD & HLD)', 'desc': 'Understand Load Balancing, Caching, Microservices, and Database Sharding.'},
        {'id': 'cse_y3_4', 'title': 'Summer Internship at Product/Startup Company', 'desc': 'Secure 8-12 week software engineering internship via LinkedIn/Campus.'},
        {'id': 'cse_y3_5', 'title': 'Cloud Certification (AWS / GCP / Azure)', 'desc': 'Earn AWS Certified Cloud Practitioner or Google Cloud Associate.'},
        {'id': 'cse_y3_6', 'title': 'Mock Technical Interviews & Resume Building', 'desc': 'Conduct 10+ peer mock interviews and design ATS-compliant single-page resume.'},
      ],
      4: [
        {'id': 'cse_y4_1', 'title': 'Production Capstone Project & Deployment', 'desc': 'Deploy scalable AI/Web project live on AWS/Vercel with CI/CD pipelines.'},
        {'id': 'cse_y4_2', 'title': 'Campus Placement Drives (Tier 1 & 2 Companies)', 'desc': 'Crack Online Coding Assessments (OA) and technical interview rounds.'},
        {'id': 'cse_y4_3', 'title': 'Competitive Programming Bootcamp', 'desc': 'Practice Codeforces / LeetCode Hard problems for high-LPA product roles.'},
        {'id': 'cse_y4_4', 'title': 'Open Source Contributions', 'desc': 'Submit Pull Requests to popular GitHub repositories or Hacktoberfest.'},
        {'id': 'cse_y4_5', 'title': 'GATE CS / Higher Studies (GRE/TOEFL) Prep', 'desc': 'Prepare backup pathway for M.Tech at IITs or MS in US/Europe.'},
        {'id': 'cse_y4_6', 'title': 'Final Year Thesis & Industry Offer Acceptance', 'desc': 'Complete degree requirements and finalize job offer onboarding.'},
      ],
    },
    'Information Technology (IT)': {
      1: [
        {'id': 'it_y1_1', 'title': 'IT Fundamentals & C/Python Coding', 'desc': 'Master basic syntax, data types, control structures, and file systems.'},
        {'id': 'it_y1_2', 'title': 'Web Technologies (HTML5, CSS3, JavaScript)', 'desc': 'Learn responsive design, DOM manipulation, and modern web standards.'},
        {'id': 'it_y1_3', 'title': 'Linux System Administration Basics', 'desc': 'Master terminal commands, user privileges, file permissions, and shell scripts.'},
        {'id': 'it_y1_4', 'title': 'Git & Code Management', 'desc': 'Set up GitHub repository, manage branches, and learn open source basics.'},
        {'id': 'it_y1_5', 'title': 'Computer Hardware & Networking Basics', 'desc': 'Understand network topologies, Ethernet cables, routers, and switches.'},
        {'id': 'it_y1_6', 'title': 'Technical Writing & Presentation', 'desc': 'Learn documentation standards and create technical project proposals.'},
      ],
      2: [
        {'id': 'it_y2_1', 'title': 'Data Structures & Algorithms', 'desc': 'Master stacks, queues, trees, graphs, searching, and sorting algorithms.'},
        {'id': 'it_y2_2', 'title': 'Relational & NoSQL Databases', 'desc': 'Master SQL queries, MySQL, PostgreSQL, MongoDB, and ORM tools.'},
        {'id': 'it_y2_3', 'title': 'Computer Networks & Security Protocols', 'desc': 'Study TCP/IP stack, DNS, DHCP, Firewalls, SSL/TLS, and VPNs.'},
        {'id': 'it_y2_4', 'title': 'Object-Oriented Software Design', 'desc': 'Learn Java / C# with design patterns (Factory, Singleton, MVC).'},
        {'id': 'it_y2_5', 'title': 'Cloud Fundamentals (AWS/Azure)', 'desc': 'Learn EC2, S3, IAM, VPC, and deployment basics.'},
        {'id': 'it_y2_6', 'title': 'Full-Stack Web App Development', 'desc': 'Build Node.js/Python backend with React/Flutter frontend.'},
      ],
      3: [
        {'id': 'it_y3_1', 'title': 'Enterprise System Architecture & Microservices', 'desc': 'Study RESTful APIs, GraphQL, Docker containers, and Kubernetes basics.'},
        {'id': 'it_y3_2', 'title': 'Cybersecurity & Ethical Hacking Basics', 'desc': 'Study OWASP Top 10 vulnerabilities, penetration testing, and encryption.'},
        {'id': 'it_y3_3', 'title': 'DevOps & CI/CD Pipelines', 'desc': 'Implement GitHub Actions, Jenkins, Terraform, and automated testing.'},
        {'id': 'it_y3_4', 'title': 'Summer IT Internship', 'desc': '8-12 week software/cloud engineering internship at product company or MNC.'},
        {'id': 'it_y3_5', 'title': 'Cloud Certification (AWS SAA / Azure Admin)', 'desc': 'Clear AWS Solutions Architect Associate or Microsoft Azure Administrator.'},
        {'id': 'it_y3_6', 'title': 'Placement Assessment & Resume Prep', 'desc': 'Mock technical screenings, DSA practice, and ATS resume design.'},
      ],
      4: [
        {'id': 'it_y4_1', 'title': 'Full-Stack Enterprise Capstone Project', 'desc': 'Deploy production web/cloud platform with microservices & SSL security.'},
        {'id': 'it_y4_2', 'title': 'Campus Placement Drives', 'desc': 'Crack technical interviews for Infosys, TCS Digital, Wipro Turbo, Accenture, Cognizant.'},
        {'id': 'it_y4_3', 'title': 'System Design & High-Availability Architecture', 'desc': 'Master caching (Redis), CDN, load balancing, and database sharding.'},
        {'id': 'it_y4_4', 'title': 'Data Analytics & Big Data Systems', 'desc': 'Learn Apache Spark, Hadoop, and PowerBI visualization.'},
        {'id': 'it_y4_5', 'title': 'Higher Studies (GATE/GRE) Backup', 'desc': 'Prepare backup pathway for M.Tech IT or MS in Information Systems.'},
        {'id': 'it_y4_6', 'title': 'Graduation & Job Onboarding', 'desc': 'Complete thesis defense and join enterprise IT team.'},
      ],
    },
    'Data Science & AI': {
      1: [
        {'id': 'ds_y1_1', 'title': 'Python for Data Science & Math', 'desc': 'Master NumPy, Pandas, Linear Algebra, Multivariable Calculus, and Probability.'},
        {'id': 'ds_y1_2', 'title': 'Data Visualization & EDA', 'desc': 'Create exploratory graphs using Matplotlib, Seaborn, and Plotly.'},
        {'id': 'ds_y1_3', 'title': 'SQL & Data Warehousing', 'desc': 'Master complex SQL queries, JOINs, aggregations, and PostgreSQL.'},
        {'id': 'ds_y1_4', 'title': 'Git & Jupyter Notebook Workflows', 'desc': 'Organize clean data science repositories and reproducible notebooks.'},
        {'id': 'ds_y1_5', 'title': 'Groq & LLM API Integration', 'desc': 'Build basic AI prompt engineering applications using Groq LLM API.'},
        {'id': 'ds_y1_6', 'title': 'Kaggle & Data Competitions Setup', 'desc': 'Create Kaggle profile and participate in beginner tabular datasets.'},
      ],
      2: [
        {'id': 'ds_y2_1', 'title': 'Classical Machine Learning (Scikit-Learn)', 'desc': 'Master Regression, Classification, Decision Trees, Random Forest, SVM, and Clustering.'},
        {'id': 'ds_y2_2', 'title': 'Data Structures & Algorithms', 'desc': 'Master arrays, trees, heaps, dynamic programming for technical interviews.'},
        {'id': 'ds_y2_3', 'title': 'Deep Learning Foundations (PyTorch)', 'desc': 'Understand Neural Networks, Backpropagation, Loss Functions, and PyTorch tensors.'},
        {'id': 'ds_y2_4', 'title': 'Feature Engineering & Data Preprocessing', 'desc': 'Handle missing data, encoding, scaling, PCA, and dimensionality reduction.'},
        {'id': 'ds_y2_5', 'title': 'Big Data Systems (Apache Spark & PySpark)', 'desc': 'Learn distributed data processing and Hadoop Ecosystem basics.'},
        {'id': 'ds_y2_6', 'title': 'End-to-End ML Web Application', 'desc': 'Deploy ML model with Streamlit / FastAPI backend.'},
      ],
      3: [
        {'id': 'ds_y3_1', 'title': 'Computer Vision (OpenCV & CNNs)', 'desc': 'Build image classification, object detection (YOLO), and segmentation models.'},
        {'id': 'ds_y3_2', 'title': 'Natural Language Processing (Transformers & LLMs)', 'desc': 'Master Tokenization, BERT, GPT architectures, RAG, and Vector DBs (Chroma/Pinecone).'},
        {'id': 'ds_y3_3', 'title': 'MLOps & Model Deployment', 'desc': 'Master MLflow, Docker, FastAPI, AWS SageMaker, and model monitoring.'},
        {'id': 'ds_y3_4', 'title': 'Data Science Summer Internship', 'desc': 'Secure 8-12 week AI/Data Science internship at product company or AI lab.'},
        {'id': 'ds_y3_5', 'title': 'Cloud Data Certification (AWS Machine Learning)', 'desc': 'Earn AWS Certified Machine Learning Specialist or GCP Data Engineer.'},
        {'id': 'ds_y3_6', 'title': 'Data Science Interview Prep', 'desc': 'Master statistics questions, ML system design, and coding assessments.'},
      ],
      4: [
        {'id': 'ds_y4_1', 'title': 'Production AI/LLM Capstone Project', 'desc': 'Deploy production RAG agent or vision pipeline on cloud with CI/CD.'},
        {'id': 'ds_y4_2', 'title': 'AI/Data Science Placement Drives', 'desc': 'Crack technical interviews for Data Scientist / AI Engineer roles at FAANG & startups.'},
        {'id': 'ds_y4_3', 'title': 'Research Paper Publication / Open Source AI', 'desc': 'Publish research paper or contribute to open-source PyTorch repositories.'},
        {'id': 'ds_y4_4', 'title': 'A/B Testing & Causal Inference', 'desc': 'Study experimental design, hypothesis testing, and business metrics.'},
        {'id': 'ds_y4_5', 'title': 'Higher Studies (GRE/TOEFL) Backup', 'desc': 'Prepare backup application for MS in AI / Data Science.'},
        {'id': 'ds_y4_6', 'title': 'Degree Defense & AI Offer Acceptance', 'desc': 'Finalize thesis defense and join AI engineering team.'},
      ],
    },
    'Robotics & Automation': {
      1: [
        {'id': 'rob_y1_1', 'title': 'Physics, Kinematics & C++ Programming', 'desc': 'Master classical mechanics, linear algebra, vector calculus, and C++ OOP.'},
        {'id': 'rob_y1_2', 'title': 'Electrical Circuits & Motor Controls', 'desc': 'Study DC motors, stepper motors, servo motors, motor drivers, and H-bridges.'},
        {'id': 'rob_y1_3', 'title': 'Arduino & Microcontroller Hardware Labs', 'desc': 'Interface IMUs, ultrasonic sensors, encoders, and PWM motor controllers.'},
        {'id': 'rob_y1_4', 'title': '3D CAD Modeling (SolidWorks / Fusion 360)', 'desc': 'Design 3D chassis, robotic arms, and 3D printable mechanical parts.'},
        {'id': 'rob_y1_5', 'title': 'MATLAB & Robotics Toolbox', 'desc': 'Simulate 2-DOF and 3-DOF robot arm kinematics.'},
        {'id': 'rob_y1_6', 'title': 'Join College Robotics Club & Competitions', 'desc': 'Participate in e-Yantra, Robocon, or Line Follower hackathons.'},
      ],
      2: [
        {'id': 'rob_y2_1', 'title': 'Robot Operating System (ROS / ROS2)', 'desc': 'Master Nodes, Topics, Services, Actions, Publisher/Subscriber, and RViz/Gazebo.'},
        {'id': 'rob_y2_2', 'title': 'Control Systems & PID Tuning', 'desc': 'Study transfer functions, state-space models, stability, and PID motor controllers.'},
        {'id': 'rob_y2_3', 'title': 'PLC & Industrial Automation', 'desc': 'Learn Ladder Logic programming, SCADA, HMI, and industrial relays.'},
        {'id': 'rob_y2_4', 'title': 'Sensors & Signal Processing', 'desc': 'Interface LiDAR, Kalman Filtering, IMU sensor fusion, and encoders.'},
        {'id': 'rob_y2_5', 'title': 'Embedded STM32 / FreeRTOS', 'desc': 'Program real-time operating system tasks for hardware actuators.'},
        {'id': 'rob_y2_6', 'title': 'Build Autonomous Mobile Robot (AMR)', 'desc': 'Build a differential drive robot with obstacle avoidance.'},
      ],
      3: [
        {'id': 'rob_y3_1', 'title': 'Computer Vision for Robotics (OpenCV & ROS)', 'desc': 'Implement visual odometry, camera calibration, AprilTags, and object tracking.'},
        {'id': 'rob_y3_2', 'title': 'SLAM & Autonomous Navigation (Nav2)', 'desc': 'Master 2D/3D mapping, Gmapping, Cartographer, AMCL localization, and path planning.'},
        {'id': 'rob_y3_3', 'title': 'Forward & Inverse Kinematics / Dynamics', 'desc': 'Master Denavit-Hartenberg (DH) parameters, Jacobians, and trajectory planning.'},
        {'id': 'rob_y3_4', 'title': 'Summer Robotics Internship', 'desc': 'Internship at industrial automation company, drone startup, or warehouse tech firm.'},
        {'id': 'rob_y3_5', 'title': 'Industrial Robot Arm Programming (KUKA / ABB / FANUC)', 'desc': 'Learn teach pendant programming and industrial cell integration.'},
        {'id': 'rob_y3_6', 'title': 'Robotics Placement & Resume Prep', 'desc': 'Prepare ROS project portfolio and C++ algorithms.'},
      ],
      4: [
        {'id': 'rob_y4_1', 'title': 'Autonomous Drone or Robotic Arm Capstone', 'desc': 'Build autonomous inspection drone or 6-DOF robotic manipulator.'},
        {'id': 'rob_y4_2', 'title': 'Robotics Campus Placement Drives', 'desc': 'Prepare for technical interviews at Addverb, GreyOrange, Tata Robotics, Bosch.'},
        {'id': 'rob_y4_3', 'title': 'Reinforcement Learning & Robot Simulation', 'desc': 'Study Isaac Sim, PyBullet, and reinforcement learning for robot control.'},
        {'id': 'rob_y4_4', 'title': 'Safety Standards & ISO 10218', 'desc': 'Study cobot safety protocols, emergency stops, and industrial compliance.'},
        {'id': 'rob_y4_5', 'title': 'GATE / Higher Studies (MS Robotics) Prep', 'desc': 'Prepare application for MS in Robotics in Germany, US, or IITs.'},
        {'id': 'rob_y4_6', 'title': 'Final Thesis Defense & Onboarding', 'desc': 'Present final robotics project and join automation workforce.'},
      ],
    },
    'Chemical Engineering': {
      1: [
        {'id': 'ch_y1_1', 'title': 'General Chemistry & Physics for Engineers', 'desc': 'Study organic, inorganic, physical chemistry, and thermodynamics basics.'},
        {'id': 'ch_y1_2', 'title': 'Chemical Process Calculations (Stoichiometry)', 'desc': 'Master material balances, energy balances, bypass, and recycle streams.'},
        {'id': 'ch_y1_3', 'title': 'C & Python for Chemical Simulations', 'desc': 'Write code for solving non-linear chemical equilibrium equations.'},
        {'id': 'ch_y1_4', 'title': 'Engineering Graphics & P&ID Drawings', 'desc': 'Learn Piping & Instrumentation Diagrams (P&ID) drafting.'},
        {'id': 'ch_y1_5', 'title': 'Fluid Mechanics in Chemical Systems', 'desc': 'Study fluid statics, Bernoulli equation, pumps, and pipe friction losses.'},
        {'id': 'ch_y1_6', 'title': 'Industrial Safety & Environmental Standards', 'desc': 'Learn HAZOP analysis, chemical safety rules, and effluent standards.'},
      ],
      2: [
        {'id': 'ch_y2_1', 'title': 'Chemical Engineering Thermodynamics (CET)', 'desc': 'Master PVT behavior, phase equilibria (VLE/LLE), and fugacity.'},
        {'id': 'ch_y2_2', 'title': 'Heat Transfer Operations (HTO)', 'desc': 'Design shell-and-tube heat exchangers, evaporators, and reboilers.'},
        {'id': 'ch_y2_3', 'title': 'Mass Transfer Operations-I (MTO-1)', 'desc': 'Study diffusion, gas absorption, humidification, and drying.'},
        {'id': 'ch_y2_4', 'title': 'Mechanical Operations & Particle Tech', 'desc': 'Study crushing, grinding, filtration, sedimentation, and cyclones.'},
        {'id': 'ch_y2_5', 'title': 'Process Instrumentation & Control', 'desc': 'Learn temperature/pressure sensors, control valves, and PID loops.'},
        {'id': 'ch_y2_6', 'title': 'Aspen Plus / Aspen HYSYS Basics', 'desc': 'Simulate basic unit operations in chemical process software.'},
      ],
      3: [
        {'id': 'ch_y3_1', 'title': 'Chemical Reaction Engineering (CRE)', 'desc': 'Design Batch reactors, CSTR, Plug Flow Reactors (PFR), and catalysis.'},
        {'id': 'ch_y3_2', 'title': 'Mass Transfer Operations-II (Distillation & Extraction)', 'desc': 'Design distillation columns (McCabe-Thiele), liquid extraction, and crystallization.'},
        {'id': 'ch_y3_3', 'title': 'Chemical Process Technology & Refining', 'desc': 'Study petroleum refining, fertilizers, polymers, and pharmaceutical manufacturing.'},
        {'id': 'ch_y3_4', 'title': 'Summer Industrial Refinery Internship', 'desc': 'Internship at Reliance Industries, IOCL, HPCL, BPCL, Cipla, or Dr. Reddy\'s.'},
        {'id': 'ch_y3_5', 'title': 'Plant Design & Process Economics', 'desc': 'Estimate capital investment, operating costs, and profitability analysis.'},
        {'id': 'ch_y3_6', 'title': 'GATE CH Exam Preparation', 'desc': 'Solve 10 years of GATE Chemical papers for PSU recruitment.'},
      ],
      4: [
        {'id': 'ch_y4_1', 'title': 'Comprehensive Chemical Plant Design Project', 'desc': 'Design complete chemical plant process with P&ID and cost estimation.'},
        {'id': 'ch_y4_2', 'title': 'Chemical Campus Placement Drives', 'desc': 'Prepare for Reliance, Shell, Schlumberger, Asian Paints, BASF, Technip.'},
        {'id': 'ch_y4_3', 'title': 'Advanced Process Optimization (Aspen HYSYS)', 'desc': 'Optimize energy consumption and yield in industrial plants.'},
        {'id': 'ch_y4_4', 'title': 'Biochemical & Pharmaceutical Engineering', 'desc': 'Study fermenters, bioreactors, and downstream purification.'},
        {'id': 'ch_y4_5', 'title': 'GATE CH Exam & PSU Officer Applications', 'desc': 'Sit for GATE for Executive Officer roles in IOCL, HPCL, ONGC, GAIL.'},
        {'id': 'ch_y4_6', 'title': 'Degree Defense & Industrial Onboarding', 'desc': 'Finalize plant design thesis and join process engineering team.'},
      ],
    },
    'ECE': {
      1: [
        {'id': 'ece_y1_1', 'title': 'Engineering Physics & Circuit Theory', 'desc': 'Understand KVL, KCL, mesh analysis, electromagnetism, and semiconductor physics.'},
        {'id': 'ece_y1_2', 'title': 'Programming in C & Embedded Logic', 'desc': 'Master pointer manipulation, bitwise operations, and memory structures.'},
        {'id': 'ece_y1_3', 'title': 'Arduino & Basic Sensors Experimentation', 'desc': 'Interface LEDs, ultrasonic sensors, motors, and LCDs with microcontrollers.'},
        {'id': 'ece_y1_4', 'title': 'Engineering Graphics & CAD Basics', 'desc': 'Learn 2D schematic drawing and component symbol standards.'},
        {'id': 'ece_y1_5', 'title': 'MATLAB Basics for Engineers', 'desc': 'Write scripts for matrix operations, signal plotting, and mathematical modeling.'},
        {'id': 'ece_y1_6', 'title': 'Join Robotics & IEEE Student Branch', 'desc': 'Participate in college hardware hackathons and tech fests.'},
      ],
      2: [
        {'id': 'ece_y2_1', 'title': 'Electronic Devices & Circuits (EDC)', 'desc': 'Master Diodes, BJT, MOSFET amplifiers, and frequency response analysis.'},
        {'id': 'ece_y2_2', 'title': 'Digital Electronics & Verilog HDL', 'desc': 'Study logic gates, flip-flops, multiplexers, counters, and write Verilog code.'},
        {'id': 'ece_y2_3', 'title': 'Signals & Systems Analysis', 'desc': 'Master Fourier Transform, Laplace Transform, Z-Transform, and LTI Systems.'},
        {'id': 'ece_y2_4', 'title': 'ESP32 / STM32 Microcontroller Labs', 'desc': 'Program 32-bit ARM microcontrollers using C/C++ and FreeRTOS basics.'},
        {'id': 'ece_y2_5', 'title': 'PCB Design & Fabrication (EasyEDA / KiCAD)', 'desc': 'Design schematic, route PCB traces, and fabricate custom hardware board.'},
        {'id': 'ece_y2_6', 'title': 'Microprocessors 8086 & 8051 Assembly', 'desc': 'Learn register architectures, memory mapping, and assembly coding.'},
      ],
      3: [
        {'id': 'ece_y3_1', 'title': 'VLSI Design & Physical Synthesis Flow', 'desc': 'Master CMOS layout design, static timing analysis (STA), Cadence/Synopsys tools.'},
        {'id': 'ece_y3_2', 'title': 'Digital Signal Processing (DSP) & FPGA', 'desc': 'Implement FIR/IIR filters on FPGA boards (Xilinx Spartan/Artix).'},
        {'id': 'ece_y3_3', 'title': 'Analog Circuits & IC Design', 'desc': 'Study Op-Amps, Oscillators, PLLs, and Analog-to-Digital Converters (ADC).'},
        {'id': 'ece_y3_4', 'title': 'Core Industry Internship (Semiconductor / IoT)', 'desc': 'Secure summer internship at Intel, Qualcomm, Texas Instruments, or Bosch.'},
        {'id': 'ece_y3_5', 'title': 'Wireless Communication & Antennas', 'desc': 'Study 5G, Wi-Fi, Bluetooth, RFID, and RF circuit fundamentals.'},
        {'id': 'ece_y3_6', 'title': 'GATE EC Preparation & Mock Tests', 'desc': 'Solve 10 years of GATE EC previous papers for PSU / M.Tech admissions.'},
      ],
      4: [
        {'id': 'ece_y4_1', 'title': 'System-on-Chip (SoC) Capstone Project', 'desc': 'Design and fabricate/test a complete IoT node or FPGA accelerator.'},
        {'id': 'ece_y4_2', 'title': 'Core Hardware Placement Drives', 'desc': 'Crack technical rounds for Intel, Qualcomm, Mediatek, AMD, NXP, and BEL.'},
        {'id': 'ece_y4_3', 'title': 'Software / IT Backup Placement Prep', 'desc': 'Practice Data Structures & C++ to keep IT product roles open.'},
        {'id': 'ece_y4_4', 'title': 'Embedded RTOS & Firmware Masterclass', 'desc': 'Master mutexes, semaphores, task scheduling, and UART/SPI/I2C protocols.'},
        {'id': 'ece_y4_5', 'title': 'GATE EC Exam & PSU Job Applications', 'desc': 'Sit for GATE exam for ISRO, DRDO, BEL, BHEL, and IOCL scientist roles.'},
        {'id': 'ece_y4_6', 'title': 'Final Degree Defense & Career Onboarding', 'desc': 'Present final year thesis and transition into hardware industry.'},
      ],
    },
    'Electrical': {
      1: [
        {'id': 'eee_y1_1', 'title': 'Basic Electrical Engineering (BEE)', 'desc': 'Master KVL, KCL, AC/DC circuit analysis, and single-phase transformer basics.'},
        {'id': 'eee_y1_2', 'title': 'Engineering Physics & Electromagnetics', 'desc': 'Study Maxwell equations, magnetic circuits, flux density, and induction.'},
        {'id': 'eee_y1_3', 'title': 'C Programming & MATLAB Simulations', 'desc': 'Write algorithms for circuit equations and matrix mathematical analysis.'},
        {'id': 'eee_y1_4', 'title': 'Electrical Workshop & Wiring Practice', 'desc': 'Hands-on training in earthing, relay wiring, safety breakers, and panel wiring.'},
        {'id': 'eee_y1_5', 'title': 'Engineering Graphics & Circuit Schematics', 'desc': 'Learn single-line diagrams, electrical schematic drafting in AutoCAD.'},
        {'id': 'eee_y1_6', 'title': 'Join Energy & Green Tech Student Clubs', 'desc': 'Participate in renewable energy and solar power innovation projects.'},
      ],
      2: [
        {'id': 'eee_y2_1', 'title': 'Electrical Machines-I (DC Machines & Transformers)', 'desc': 'Master DC generators, motors, 3-phase transformers, testing, and efficiency.'},
        {'id': 'eee_y2_2', 'title': 'Analog & Digital Electronics for EEE', 'desc': 'Study Op-Amps, logic gates, ADC/DAC converters, and power supplies.'},
        {'id': 'eee_y2_3', 'title': 'Network Analysis & Synthesis', 'desc': 'Master Laplace transforms, two-port networks, resonance, and transient response.'},
        {'id': 'eee_y2_4', 'title': 'Electromagnetic Field Theory', 'desc': 'Analyze electrostatics, magnetostatics, plane waves, and transmission lines.'},
        {'id': 'eee_y2_5', 'title': 'Power System Generation & Economics', 'desc': 'Study thermal, hydro, nuclear, solar generation, and load curves.'},
        {'id': 'eee_y2_6', 'title': 'Microcontrollers & PLC Automation', 'desc': 'Program Arduino/8051 and learn ladder logic for Industrial Automation.'},
      ],
      3: [
        {'id': 'eee_y3_1', 'title': 'Power Electronics (Inverters & Converters)', 'desc': 'Master SCR, MOSFET, IGBT, choppers, cycloconverters, and PWM drives.'},
        {'id': 'eee_y3_2', 'title': 'Electrical Machines-II (AC Motors & Alternators)', 'desc': 'Study 3-phase induction motors, synchronous generators, and v-curves.'},
        {'id': 'eee_y3_3', 'title': 'Control Systems Engineering', 'desc': 'Analyze Root Locus, Bode plots, Nyquist stability, and PID controllers.'},
        {'id': 'eee_y3_4', 'title': 'Power System Analysis & Protection (PSAP)', 'desc': 'Master fault analysis, bus matrices, circuit breakers, and numerical relays.'},
        {'id': 'eee_y3_5', 'title': 'Summer Internship (Power Grid / Solar / EV)', 'desc': 'Internship at PGCIL, NTPC, Schneider Electric, ABB, Siemens, or Tata Power.'},
        {'id': 'eee_y3_6', 'title': 'GATE EE Preparation & Test Series', 'desc': 'Solve 10 years of GATE EE papers for PSU scientist & M.Tech admissions.'},
      ],
      4: [
        {'id': 'eee_y4_1', 'title': 'Electric Vehicle (EV) Powertrains & Battery Mgmt', 'desc': 'Design BLDC/PMSM motor drives and Li-ion Battery Management Systems (BMS).'},
        {'id': 'eee_y4_2', 'title': 'Smart Grid, Microgrid & Renewable Integration', 'desc': 'Study MPPT algorithms, solar inverters, grid synchronization, and SCADA.'},
        {'id': 'eee_y4_3', 'title': 'Capstione Hardware/Simulation Project', 'desc': 'Build hardware prototype for EV charger, solar inverter, or smart meter.'},
        {'id': 'eee_y4_4', 'title': 'Core Electrical Placement Drives', 'desc': 'Crack technical interviews for L&T, ABB, Siemens, Schneider, BHEL, BEL.'},
        {'id': 'eee_y4_5', 'title': 'GATE EE Exam & PSU Officer Applications', 'desc': 'Sit for GATE for Executive Engineer posts in PGCIL, NTPC, IOCL, ISRO.'},
        {'id': 'eee_y4_6', 'title': 'Degree Completion & Electrical Charter Registration', 'desc': 'Finalize thesis and transition into core electrical / EV sector.'},
      ],
    },
    'Mechanical': {
      1: [
        {'id': 'mech_y1_1', 'title': 'Engineering Mechanics & Statics', 'desc': 'Master force vectors, equilibrium, friction, centroids, and moment of inertia.'},
        {'id': 'mech_y1_2', 'title': 'Engineering Graphics & 2D CAD (AutoCAD)', 'desc': 'Master orthographic projections, isometric views, and drafting standards.'},
        {'id': 'mech_y1_3', 'title': 'Workshop Practice & Manufacturing', 'desc': 'Hands-on experience in fitting, carpentry, welding, smithy, and machining.'},
        {'id': 'mech_y1_4', 'title': 'Thermodynamics Foundations', 'desc': 'Study 1st and 2nd laws of thermodynamics, entropy, and ideal gas cycles.'},
        {'id': 'mech_y1_5', 'title': 'Python / C Programming for Engineers', 'desc': 'Learn coding basics for solving numerical engineering problems.'},
        {'id': 'mech_y1_6', 'title': 'SAE / BAJA / Formula Student Club', 'desc': 'Join college automotive design and fabrication team.'},
      ],
      2: [
        {'id': 'mech_y2_1', 'title': 'Strength of Materials (SOM)', 'desc': 'Analyze stress, strain, bending moments, shear forces, and Mohr\'s circle.'},
        {'id': 'mech_y2_2', 'title': 'Fluid Mechanics & Hydraulic Machines', 'desc': 'Study Bernoulli equation, pipe flow, pumps, and hydro turbines.'},
        {'id': 'mech_y2_3', 'title': '3D CAD Modeling (SolidWorks / CATIA)', 'desc': 'Master parametric 3D modeling, assembly design, and BOM generation.'},
        {'id': 'mech_y2_4', 'title': 'Kinematics & Dynamics of Machines', 'desc': 'Analyze gear trains, cams, governors, flywheels, and balancing.'},
        {'id': 'mech_y2_5', 'title': 'Manufacturing Technology & CNC', 'desc': 'Learn casting, forming, G-code/M-code programming, and CNC machining.'},
        {'id': 'mech_y2_6', 'title': 'Material Science & Heat Treatment', 'desc': 'Study iron-carbon diagram, phase transformations, and alloy steels.'},
      ],
      3: [
        {'id': 'mech_y3_1', 'title': 'Heat & Mass Transfer (HMT)', 'desc': 'Master conduction, convection, radiation, and heat exchanger design.'},
        {'id': 'mech_y3_2', 'title': 'Finite Element Analysis (FEA with ANSYS)', 'desc': 'Perform structural, thermal, and modal analysis on CAD components.'},
        {'id': 'mech_y3_3', 'title': 'Design of Machine Elements (DME)', 'desc': 'Design shafts, keys, couplings, springs, bearings, and spur gears.'},
        {'id': 'mech_y3_4', 'title': 'Summer Industrial Internship', 'desc': 'Complete 6-8 week training at Tata Motors, L&T, Mahindra, or Bosch.'},
        {'id': 'mech_y3_5', 'title': 'Automobile & EV Technology', 'desc': 'Study IC engines, electric powertrains, battery management, and hybrid systems.'},
        {'id': 'mech_y3_6', 'title': 'GATE ME Preparation & Series', 'desc': 'Solve GATE Mechanical subject tests and previous year papers.'},
      ],
      4: [
        {'id': 'mech_y4_1', 'title': 'Industrial Capstone Project', 'desc': 'Design and fabricate an automated mechanism, robot, or thermal rig.'},
        {'id': 'mech_y4_2', 'title': 'Core Campus Placement Drives', 'desc': 'Prepare for technical interviews at Tata Steel, JSW, Maruti, L&T, Siemens.'},
        {'id': 'mech_y4_3', 'title': 'Computational Fluid Dynamics (CFD / Fluent)', 'desc': 'Run flow simulations over airfoils, ducts, and cooling jackets.'},
        {'id': 'mech_y4_4', 'title': 'Industrial Engineering & Operations', 'desc': 'Study supply chain, Lean Six Sigma, PPC, and inventory control.'},
        {'id': 'mech_y4_5', 'title': 'GATE ME Exam & PSU Recruitment', 'desc': 'Appear for GATE exam targeting ONGC, NTPC, IOCL, HPCL, GAIL.'},
        {'id': 'mech_y4_6', 'title': 'Degree Completion & Career Onboarding', 'desc': 'Finalize project thesis and join core manufacturing / R&D workforce.'},
      ],
    },
    'Civil': {
      1: [
        {'id': 'civ_y1_1', 'title': 'Engineering Mechanics & Vector Statics', 'desc': 'Study force systems, trusses, friction, centroids, and moment of inertia.'},
        {'id': 'civ_y1_2', 'title': 'Basic Surveying & Levelling', 'desc': 'Learn chain surveying, compass, dumpy level, and plane table methods.'},
        {'id': 'civ_y1_3', 'title': 'Engineering Graphics & Construction Drawing', 'desc': 'Master building projections, plan/elevation drawing, and AutoCAD Civil.'},
        {'id': 'civ_y1_4', 'title': 'Building Materials & Chemistry', 'desc': 'Study cement, aggregates, bricks, timber, steel, and mortar properties.'},
        {'id': 'civ_y1_5', 'title': 'C Programming & Computational Math', 'desc': 'Write code for solving matrix structures and surveying calculations.'},
        {'id': 'civ_y1_6', 'title': 'Site Visit to Infrastructure Projects', 'desc': 'Visit active residential, bridge, or highway construction sites.'},
      ],
      2: [
        {'id': 'civ_y2_1', 'title': 'Strength of Materials & Structural Analysis-I', 'desc': 'Master SFD, BMD, deflections, indeterminate beams, and column buckling.'},
        {'id': 'civ_y2_2', 'title': 'Fluid Mechanics & Hydraulics', 'desc': 'Study hydrostatics, pipe networks, open channel flow, and weir discharge.'},
        {'id': 'civ_y2_3', 'title': 'Advanced Surveying (Total Station & GPS)', 'desc': 'Operate Total Station, GIS software, and GPS surveying equipment.'},
        {'id': 'civ_y2_4', 'title': 'Concrete Technology & Mix Design', 'desc': 'Design concrete mix grades (M20-M50) and test compressive strength.'},
        {'id': 'civ_y2_5', 'title': 'Soil Mechanics & Geotechnical Engg', 'desc': 'Study soil classification, permeability, shear strength, and compaction.'},
        {'id': 'civ_y2_6', 'title': 'AutoCAD Civil 3D & 3D Building Models', 'desc': 'Create 3D structural building layouts and terrain contour maps.'},
      ],
      4: [
        {'id': 'civ_y4_1', 'title': 'Comprehensive Structural Capstone Project', 'desc': 'Design complete G+10 building structure with seismic analysis.'},
        {'id': 'civ_y4_2', 'title': 'Construction Project Management (Primavera / MSP)', 'desc': 'Master CPM/PERT scheduling, resource levelling, and billing.'},
        {'id': 'civ_y4_3', 'title': 'Estimation, Costing & Valuation', 'desc': 'Prepare detailed rate analysis, bill of quantities (BOQ), and tenders.'},
        {'id': 'civ_y4_4', 'title': 'Core Infrastructure Placements', 'desc': 'Prepare for L&T Construction, Afcons, Tata Projects, and Shapoorji.'},
        {'id': 'civ_y4_5', 'title': 'GATE CE Exam & Government Jobs', 'desc': 'Appear for GATE targeting CPWD, NHAI, DMRC, Railways, and State PSCs.'},
        {'id': 'civ_y4_6', 'title': 'Final Thesis & Engineering License', 'desc': 'Complete degree requirements and apply for Licensed Structural Engineer.'},
      ],
    },
    'Mechanical Engg': {
      1: [
        {'id': 'me_p1_1', 'title': 'Applied Mechanics & Basic Drawing', 'desc': 'Master engineering drawing, scales, projections, and force systems.'},
        {'id': 'me_p1_2', 'title': 'Workshop Skills (Carpentry & Fitting)', 'desc': 'Gain hands-on experience in basic tools, joints, and measurements.'},
        {'id': 'me_p1_3', 'title': 'General Science & Materials', 'desc': 'Study properties of metals, alloys, and heat treatments.'},
      ],
      2: [
        {'id': 'me_p2_1', 'title': 'Thermal Engineering & Fluids', 'desc': 'Study boilers, air compressors, and fluid machinery operations.'},
        {'id': 'me_p2_2', 'title': 'Manufacturing & Tool Tech', 'desc': 'Understand lathe operations, milling, drilling, and metal casting.'},
        {'id': 'me_p2_3', 'title': 'CAD Drafting (2D & 3D)', 'desc': 'Learn computer-aided design using AutoCAD for assembly drafting.'},
      ],
      3: [
        {'id': 'me_p3_1', 'title': 'CNC Programming & Automation', 'desc': 'Write G-codes and M-codes for automated CNC lathe machining.'},
        {'id': 'me_p3_2', 'title': 'Plant Maintenance & Quality Control', 'desc': 'Understand machine wear-and-tear, lubrication, and ISO standards.'},
        {'id': 'me_p3_3', 'title': 'Final Industrial Project & Placement', 'desc': 'Build a mechanical model and prepare for core junior engineer roles.'},
      ],
    },
    'Civil Engg': {
      1: [
        {'id': 'ci_p1_1', 'title': 'Basic Surveying & Levelling', 'desc': 'Learn measurement using chains, tapes, compass, and dumpy level.'},
        {'id': 'ci_p1_2', 'title': 'Construction Materials', 'desc': 'Study properties of stones, bricks, cement, concrete, and timber.'},
        {'id': 'ci_p1_3', 'title': 'Building Drawing & CAD', 'desc': 'Draw plans, elevations, and sections of building structures.'},
      ],
      2: [
        {'id': 'ci_p2_1', 'title': 'Concrete Tech & Quality Control', 'desc': 'Test compressive strength, workability, and grade mixing standards.'},
        {'id': 'ci_p2_2', 'title': 'Soil Mechanics & Foundations', 'desc': 'Understand soil bearing capacity, settlement, and foundation types.'},
        {'id': 'ci_p2_3', 'title': 'Water Supply & Sanitation', 'desc': 'Study pipelines, sewage disposal systems, and plumbing layout.'},
      ],
      3: [
        {'id': 'ci_p3_1', 'title': 'Estimation, Costing & Billing', 'desc': 'Calculate quantities of materials, rate analysis, and run bills.'},
        {'id': 'ci_p3_2', 'title': 'Construction Site Practice', 'desc': 'Internship on safety, concrete pouring, reinforcement check, and reports.'},
        {'id': 'ci_p3_3', 'title': 'Final Project & Junior Engineer Prep', 'desc': 'Submit a structural layout design project and practice state exam MCQ tests.'},
      ],
    },
    'Electrical Engg': {
      1: [
        {'id': 'el_p1_1', 'title': 'Basic Electrical Workshop & Circuits', 'desc': 'Master house wiring, jointing, soldering, and Ohm\'s/Kirchhoff\'s laws.'},
        {'id': 'el_p1_2', 'title': 'Electrical Instruments', 'desc': 'Learn to use ammeter, voltmeter, wattmeter, and multimeter.'},
        {'id': 'el_p1_3', 'title': 'Electrical Materials & Safety', 'desc': 'Study conductors, insulators, magnetic materials, and safety codes.'},
      ],
      2: [
        {'id': 'el_p2_1', 'title': 'AC & DC Machines Practice', 'desc': 'Operate and test DC motors, generators, and single-phase transformers.'},
        {'id': 'el_p2_2', 'title': 'Electrical Power Systems', 'desc': 'Study generation, transmission lines, substation equipment, and switches.'},
        {'id': 'el_p2_3', 'title': 'Industrial Control & Wiring', 'desc': 'Understand motor starters, contactors, relays, and panel wiring.'},
      ],
      3: [
        {'id': 'el_p3_1', 'title': 'PLC Programming & Automation', 'desc': 'Learn basic ladder logic for automated conveyor and machine controls.'},
        {'id': 'el_p3_2', 'title': 'Electrical Estimation & Testing', 'desc': 'Prepare material lists and cost estimates for residential/industrial setups.'},
        {'id': 'el_p3_3', 'title': 'Final Practical Project & Placements', 'desc': 'Build a power control module and attend power grid/utility placements.'},
      ],
    },
    'Computer Engg': {
      1: [
        {'id': 'co_p1_1', 'title': 'PC Hardware & OS Installation', 'desc': 'Assemble a PC, install Windows/Linux, and partition drives.'},
        {'id': 'co_p1_2', 'title': 'Office Automation & Typing', 'desc': 'Master word processing, spreadsheets, presentations, and technical typing.'},
        {'id': 'co_p1_3', 'title': 'C Programming Basics', 'desc': 'Write programs with loops, arrays, basic functions, and structures.'},
      ],
      2: [
        {'id': 'co_p2_1', 'title': 'Hardware, Networking & TCP/IP', 'desc': 'Configure LAN connections, IP routing, crimping, and subnets.'},
        {'id': 'co_p2_2', 'title': 'Database & SQL Operations', 'desc': 'Write SELECT, INSERT, UPDATE queries and design relational databases.'},
        {'id': 'co_p2_3', 'title': 'Web Development (HTML & CSS)', 'desc': 'Create responsive static layouts and host them on local servers.'},
      ],
      3: [
        {'id': 'co_p3_1', 'title': 'Java Programming & Mobile Basics', 'desc': 'Implement Object-Oriented principles and learn basic Android layout.'},
        {'id': 'co_p3_2', 'title': 'IT Troubleshooting & Tech Support', 'desc': 'Solve hardware faults, OS crashes, and malware cleaning.'},
        {'id': 'co_p3_3', 'title': 'Final Application Project & Junior Dev Prep', 'desc': 'Develop a simple database application and build resume for support/dev roles.'},
      ],
    },
    'Electronics Engg': {
      1: [
        {'id': 'ex_p1_1', 'title': 'Basic Electronic Components & Solder', 'desc': 'Identify resistors, capacitors, diodes, and master PCB soldering.'},
        {'id': 'ex_p1_2', 'title': 'Digital Circuits & Gates', 'desc': 'Verify truth tables of logic gates, flip-flops, and counters.'},
        {'id': 'ex_p1_3', 'title': 'Analog Electronics Basics', 'desc': 'Understand rectifiers, filters, regulators, and transistor biasing.'},
      ],
      2: [
        {'id': 'ex_p2_1', 'title': 'Microcontrollers & Arduino', 'desc': 'Write code to interface LEDs, sensors, and LCDs with Arduino.'},
        {'id': 'ex_p2_2', 'title': 'Communication & Telecom', 'desc': 'Understand AM, FM, digital modulation, and fiber optic cabling.'},
        {'id': 'ex_p2_3', 'title': 'PCB Design & Prototyping', 'desc': 'Design circuit layouts on computers and etch copper boards.'},
      ],
      3: [
        {'id': 'ex_p3_1', 'title': 'Consumer Electronics Repair', 'desc': 'Troubleshoot and fix audio systems, power supplies, and TV displays.'},
        {'id': 'ex_p3_2', 'title': 'Industrial Instrumentation', 'desc': 'Understand transducers, temperature controllers, and calibration.'},
        {'id': 'ex_p3_3', 'title': 'Final Embedded Project & Core Placements', 'desc': 'Build a sensor-based prototype and prepare for hardware tech jobs.'},
      ],
    },
    'Automobile Engg': {
      1: [
        {'id': 'au_p1_1', 'title': 'Auto Workshop & Hand Tools', 'desc': 'Learn dismantling and assembly of basic engine components.'},
        {'id': 'au_p1_2', 'title': 'Automobile Components & Materials', 'desc': 'Study parts of IC engines, chassis frames, and gear systems.'},
        {'id': 'au_p1_3', 'title': 'Applied Physics & Thermodynamics', 'desc': 'Understand 2-stroke/4-stroke cycles and compression systems.'},
      ],
      2: [
        {'id': 'au_p2_1', 'title': 'Transmission & Suspension Systems', 'desc': 'Study clutches, manual/auto gearboxes, differentials, and shockers.'},
        {'id': 'au_p2_2', 'title': 'Vehicle Diagnostics & Tuning', 'desc': 'Perform emission tests, wheel alignment, and engine tuning.'},
        {'id': 'au_p2_3', 'title': 'EV Systems & Hybrid Engines', 'desc': 'Learn battery configurations, electric motors, and regenerative braking.'},
      ],
      3: [
        {'id': 'au_p3_1', 'title': 'Auto Electricals & ECU Systems', 'desc': 'Troubleshoot wiring, alternators, starters, and electronic sensors.'},
        {'id': 'au_p3_2', 'title': 'Garage Management & Insurance', 'desc': 'Understand service scheduling, customer billing, and accident estimation.'},
        {'id': 'au_p3_3', 'title': 'Final Prototype Project & Automotive Jobs', 'desc': 'Perform engine rebuilding/EV retrofit and interview at service centers/plants.'},
      ],
    },
    'Chemical Engg': {
      1: [
        {'id': 'ch_p1_1', 'title': 'Process Calculations', 'desc': 'Master material balance and energy balance in chemical systems.'},
        {'id': 'ch_p1_2', 'title': 'Fluid Flow Operations', 'desc': 'Study pumps, piping layouts, valves, and flow meters.'},
        {'id': 'ch_p1_3', 'title': 'General Chemistry & Lab Safety', 'desc': 'Understand safety protocols, hazardous materials, and lab reagents.'},
      ],
      2: [
        {'id': 'ch_p2_1', 'title': 'Heat & Mass Transfer', 'desc': 'Study heat exchangers, evaporators, distillation, and absorption.'},
        {'id': 'ch_p2_2', 'title': 'Chemical Reaction Engineering', 'desc': 'Learn reactor types, kinetics, and catalyst configurations.'},
        {'id': 'ch_p2_3', 'title': 'Mechanical Operations', 'desc': 'Understand filtration, crushing, mixing, and particle size reduction.'},
      ],
      3: [
        {'id': 'ch_p3_1', 'title': 'Process Control & Safety Systems', 'desc': 'Understand control loops, sensors, and emergency shutdown systems.'},
        {'id': 'ch_p3_2', 'title': 'Chemical Plant Practice & Tour', 'desc': 'Industrial site tour and internship in safety and plant operation.'},
        {'id': 'ch_p3_3', 'title': 'Final Plant Design Project & Placements', 'desc': 'Create a process flow diagram and prepare for refinery/chemical jobs.'},
      ],
    },
    'BCA': {
      1: [
        {'id': 'bca_y1_1', 'title': 'Computer Fundamentals & Office', 'desc': 'Understand operating systems, file directories, and productivity suites.'},
        {'id': 'bca_y1_2', 'title': 'Programming in C', 'desc': 'Master syntax, arrays, loops, structures, and pointer concepts.'},
        {'id': 'bca_y1_3', 'title': 'Mathematical Foundations', 'desc': 'Learn set theory, relations, functions, logic, and graph theory.'},
      ],
      2: [
        {'id': 'bca_y2_1', 'title': 'Data Structures & OOPs in Java', 'desc': 'Implement lists, stacks, trees and master inheritance and polymorphism.'},
        {'id': 'bca_y2_2', 'title': 'DBMS & SQL Foundations', 'desc': 'Design databases, enforce constraints, and write complex queries.'},
        {'id': 'bca_y2_3', 'title': 'Web Technologies (HTML, CSS, JS)', 'desc': 'Build responsive sites, implement forms, and validate client-side data.'},
      ],
      3: [
        {'id': 'bca_y3_1', 'title': 'Software Engineering & Testing', 'desc': 'Study software lifecycle, UML diagrams, manual and automated testing.'},
        {'id': 'bca_y3_2', 'title': 'Mobile App / Full Stack Dev', 'desc': 'Build a practical database-backed app using Node/Python or Flutter.'},
        {'id': 'bca_y3_3', 'title': 'Final Capstone Project & Placements', 'desc': 'Secure placements by solving coding problems and submitting a live project.'},
      ],
    },
    'BSc (Computer Science)': {
      1: [
        {'id': 'bsc_y1_1', 'title': 'Programming with Python', 'desc': 'Learn scripts, packages, file operations, and data analysis basics.'},
        {'id': 'bsc_y1_2', 'title': 'Digital Logic & Computer Design', 'desc': 'Verify basic gates, adders, multiplexers, and register transfers.'},
        {'id': 'bsc_y1_3', 'title': 'Discrete Structures', 'desc': 'Learn combinatorics, probability, matrices, and recurrence relation.'},
      ],
      2: [
        {'id': 'bsc_y2_1', 'title': 'Algorithms & Complexities', 'desc': 'Analyze sorting, searching, time complexities (Big-O), and recursion.'},
        {'id': 'bsc_y2_2', 'title': 'Operating Systems & Networks', 'desc': 'Understand memory paging, processes, routing, and sockets.'},
        {'id': 'bsc_y2_3', 'title': 'Software Development Project', 'desc': 'Create desktop or console application using Python/C++ with file DB.'},
      ],
      3: [
        {'id': 'bsc_y3_1', 'title': 'Artificial Intelligence Basics', 'desc': 'Learn search algorithms, supervised learning, and regression model tools.'},
        {'id': 'bsc_y3_2', 'title': 'Data Analytics & Statistics', 'desc': 'Understand distribution, hypothesis testing, and pandas visualization.'},
        {'id': 'bsc_y3_3', 'title': 'Final Project & IT Placement Drive', 'desc': 'Create an AI/Data Web App and practice aptitude and tech interviews.'},
      ],
    },
    'BBA': {
      1: [
        {'id': 'bba_y1_1', 'title': 'Principles of Management', 'desc': 'Study planning, organizing, leadership, and control theory.'},
        {'id': 'bba_y1_2', 'title': 'Business Communication', 'desc': 'Develop resume writing, presentation, and corporate speaking skills.'},
        {'id': 'bba_y1_3', 'title': 'Microeconomics & Accounts', 'desc': 'Understand supply/demand curves and basic journal/ledger bookkeeping.'},
      ],
      2: [
        {'id': 'bba_y2_1', 'title': 'Marketing Management', 'desc': 'Master the 4 Ps (Product, Price, Place, Promotion) and customer segments.'},
        {'id': 'bba_y2_2', 'title': 'Human Resource Management', 'desc': 'Understand recruitment, training, evaluation, and employee laws.'},
        {'id': 'bba_y2_3', 'title': 'Digital Marketing Bootcamp', 'desc': 'Learn SEO, SEM, social media posting, and Google Analytics.'},
      ],
      3: [
        {'id': 'bba_y3_1', 'title': 'Business Law & Ethics', 'desc': 'Study contract act, consumer rights, and corporate governance.'},
        {'id': 'bba_y3_2', 'title': 'Summer Internship & Report', 'desc': 'Secure an 8-week corporate sales/operations training placement.'},
        {'id': 'bba_y3_3', 'title': 'Management Trainee Placements', 'desc': 'Practice Group Discussions (GD) and HR mock interviews for job drives.'},
      ],
    },
    'BCom': {
      1: [
        {'id': 'bcm_y1_1', 'title': 'Financial Accounting', 'desc': 'Master double-entry bookkeeping, trial balance, and profit & loss.'},
        {'id': 'bcm_y1_2', 'title': 'Business Economics & Law', 'desc': 'Study contract law, sale of goods act, and macroeconomic indicators.'},
        {'id': 'bcm_y1_3', 'title': 'Business Statistics', 'desc': 'Learn mean, median, standard deviation, and correlation index.'},
      ],
      2: [
        {'id': 'bcm_y2_1', 'title': 'Corporate Accounting & Taxes', 'desc': 'Understand issue of shares, GST calculations, and corporate returns.'},
        {'id': 'bcm_y2_2', 'title': 'Cost & Management Accounting', 'desc': 'Calculate overhead allocation, marginal costing, and break-even point.'},
        {'id': 'bcm_y2_3', 'title': 'Banking, Insurance & Finance', 'desc': 'Study commercial banking, credit scoring, and insurance premiums.'},
      ],
      3: [
        {'id': 'bcm_y3_1', 'title': 'Income Tax Laws & Filing', 'desc': 'Compute salary income, house property gains, and e-file returns.'},
        {'id': 'bcm_y3_2', 'title': 'Auditing & Tally ERP Practice', 'desc': 'Learn voucher verification and practice financial entries in Tally.'},
        {'id': 'bcm_y3_3', 'title': 'Financial Analyst Placements', 'desc': 'Prepare for roles in banking, auditing, and corporate accounting drives.'},
      ],
    },
    'BSc (Biotechnology)': {
      1: [
        {'id': 'bt_y1_1', 'title': 'Cell Biology & Genetics', 'desc': 'Understand cell organelle functions, mitosis, meiosis, and Mendelian laws.'},
        {'id': 'bt_y1_2', 'title': 'General Biochemistry', 'desc': 'Study structure and metabolisms of carbohydrates, proteins, and lipids.'},
        {'id': 'bt_y1_3', 'title': 'Microbiology Lab Skills', 'desc': 'Master culture media preparation, sterilization, and staining.'},
      ],
      2: [
        {'id': 'bt_y2_1', 'title': 'Molecular Biology', 'desc': 'Study DNA replication, transcription, translation, and PCR techniques.'},
        {'id': 'bt_y2_2', 'title': 'Immunology & Pathology', 'desc': 'Understand antigens, antibodies, immune response, and diagnostics.'},
        {'id': 'bt_y2_3', 'title': 'Recombinant DNA Tech', 'desc': 'Learn gene cloning, restriction enzymes, and plasmid vectors.'},
      ],
      3: [
        {'id': 'bt_y3_1', 'title': 'Bioinformatics & Genomes', 'desc': 'Use BLAST, sequence alignments, and structural databases online.'},
        {'id': 'bt_y3_2', 'title': 'Industrial Training & Lab Project', 'desc': 'Work in a research laboratory or pharma company on diagnostic tests.'},
        {'id': 'bt_y3_3', 'title': 'Bio-Pharma Placements & Careers', 'desc': 'Prepare resumes for QC, QA, or clinical research assistant roles.'},
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final rawBranch = appProvider.profile.branch.trim();
    
    // Exact branch key normalization so every single branch gets its specific DB!
    String userBranch = 'CSE';
    final upper = rawBranch.toUpperCase();
    if (upper.contains('DATA') || upper.contains('AI')) {
      userBranch = 'Data Science & AI';
    } else if (upper.contains('ROBOT')) {
      userBranch = 'Robotics & Automation';
    } else if (upper.contains('CHEM')) {
      userBranch = 'Chemical Engineering';
    } else if (upper.contains('INFO') || upper.contains('IT')) {
      userBranch = 'Information Technology (IT)';
    } else if (upper.contains('ECE') || upper.contains('ELECTRONIC')) {
      userBranch = 'ECE';
    } else if (upper.contains('ELECT') || upper.contains('EEE')) {
      userBranch = 'Electrical';
    } else if (upper.contains('MECH') || upper.contains('AUTOMOBILE')) {
      userBranch = 'Mechanical';
    } else if (upper.contains('CIVIL') || upper.contains('STRUCTURAL')) {
      userBranch = 'Civil';
    } else {
      userBranch = 'CSE';
    }

    final milestonesMap = _branchMilestones[rawBranch] ?? _branchMilestones[userBranch] ?? _branchMilestones['CSE']!;

    // Calculate percentage progress of selected year
    double getProgressPercent(int year) {
      final list = milestonesMap[year] ?? [];
      if (list.isEmpty) return 0.0;
      int completed = 0;
      for (var task in list) {
        if (appProvider.profile.completedTasks.contains(task['id'])) {
          completed++;
        }
      }
      return completed / list.length;
    }

    final has4Years = appProvider.profile.courseLevel == 'B.Tech';
    final tabLength = has4Years ? 4 : 3;

    return DefaultTabController(
      length: tabLength,
      child: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Branch Badge
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
                            child: Text(
                              appProvider.translate('semester_planner'),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            appProvider.translate('planner_subtitle'),
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 11.5),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.school, size: 13, color: AppTheme.primaryColor),
                          const SizedBox(width: 5),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 110),
                            child: Text(
                              userBranch,
                              style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor, fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Progress Gauge Card
                AnimatedBuilder(
                  animation: DefaultTabController.of(context),
                  builder: (context, _) {
                    final controller = DefaultTabController.of(context);
                    int currentYearTab = (controller.index.clamp(0, tabLength - 1)) + 1;
                    double progress = getProgressPercent(currentYearTab);
                    return GlassCard(
                      gradientColors: [AppTheme.primaryColor.withOpacity(0.08), AppTheme.secondaryColor.withOpacity(0.02)],
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 58,
                                height: 58,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 5.5,
                                  backgroundColor: Colors.black.withOpacity(0.06),
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$userBranch Year $currentYearTab Progress',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  progress == 1.0 
                                      ? '🎉 All $userBranch Year $currentYearTab milestones completed!' 
                                      : 'Complete these real-world $userBranch milestones to boost your placement score.',
                                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 11.5, height: 1.3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Tab Bar Controls
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppTheme.isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppTheme.primaryColor,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: AppTheme.textSecondary,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    tabs: [
                      const Tab(text: 'Year 1'),
                      const Tab(text: 'Year 2'),
                      const Tab(text: 'Year 3'),
                      if (has4Years) const Tab(text: 'Year 4'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Tab views
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildMilestonesList(context, 1, appProvider, milestonesMap),
                      _buildMilestonesList(context, 2, appProvider, milestonesMap),
                      _buildMilestonesList(context, 3, appProvider, milestonesMap),
                      if (has4Years) _buildMilestonesList(context, 4, appProvider, milestonesMap),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildMilestonesList(
    BuildContext context, 
    int year, 
    AppProvider appProvider,
    Map<int, List<Map<String, dynamic>>> milestonesMap,
  ) {
    final list = milestonesMap[year] ?? [];
    return ListView.builder(
      itemCount: list.length,
      padding: const EdgeInsets.only(bottom: 20),
      itemBuilder: (context, i) {
        final task = list[i];
        final taskId = task['id'] as String;
        final isCompleted = appProvider.profile.completedTasks.contains(taskId);

        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: InkWell(
            onTap: () {
              appProvider.toggleTask(taskId);
            },
            borderRadius: BorderRadius.circular(14),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              border: Border.all(
                color: isCompleted 
                    ? AppTheme.accentColor.withOpacity(0.4) 
                    : AppTheme.borderOverlay,
                width: isCompleted ? 1.2 : 0.6,
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted ? AppTheme.accentColor : Colors.transparent,
                      border: Border.all(
                        color: isCompleted ? AppTheme.accentColor : AppTheme.textMuted,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 14,
                      color: isCompleted ? Colors.white : Colors.transparent,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['title'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                            decoration: isCompleted ? TextDecoration.lineThrough : null,
                            color: isCompleted ? AppTheme.textMuted : AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task['desc'] as String,
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 11.5,
                            height: 1.35,
                            decoration: isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
