import 'package:aichat/model/CategoryModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryController extends ChangeNotifier {
  int? _freeImagesCount;
  int get freeImagesCount => _freeImagesCount ?? 0;
  SharedPreferences? sharedPreferences;
  updateFreeImagesCount({required bool update}) async {
    sharedPreferences =
        sharedPreferences ?? (await SharedPreferences.getInstance());
    if (update) {
      _freeImagesCount = freeImagesCount + 1;
      await sharedPreferences!.setInt('remainingsCount', _freeImagesCount ?? 0);
    } else {
      if ((_freeImagesCount ?? 0) > 0) {
        _freeImagesCount = freeImagesCount - 1;

        await sharedPreferences!
            .setInt('remainingsCount', _freeImagesCount ?? 0);
      }
    }
    notifyListeners();
  }

  getFreeCounts() async {
    sharedPreferences =
        sharedPreferences ?? (await SharedPreferences.getInstance());
    _freeImagesCount = sharedPreferences!.getInt('remainingsCount');
    notifyListeners();
  }

  List<CategoryModel> categories = [
    CategoryModel(
      title: 'Ai Chat',
      type: 'chat',
      image: "images/Category/chatbot.png",
      desc: "Natural language chat, continuous conversation mode",
      isContinuous: true,
      tips: [
        "Can you write a poem?",
        "Can you write a joke?",
        "Help me plan a trip",
      ],
      content: "\nInstructions:"
          "\nYou are ChatGPT. The answer to each question should be as concise as possible. If you're making a list, don't have too many entries."
          " If possible, please format it in a friendly markdown format."
          '\n',
    ),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nI want you to act as an interviewer. I will be the candidate and you will ask me the interview questions for the position position. I want you to only reply as the interviewer. Do not write all the conservation at once. I want you to only do the interview with me. Ask me the questions and wait for my answers. Do not write explanations. Ask me the questions one by one like an interviewer does and wait for my answers."
            " If possible, please format it in a friendly markdown format."
            '\n',
        title: 'Position Interviewer',
        image: "images/Category/office_12.png",
        desc:
            "AI interviewer. As a candidate, AI will ask you interview questions for the position",
        type: 'positionInterviewer',
        tips: [
          "Hello, I'm a front-end development engineer",
          "Hello, I'm a car maintenance man",
          "Hello, I'm a financial officer",
        ]),
    CategoryModel(
        isContinuous: false,
        content: '\nnInstructions:\n'
            'I want you to act as a translator. You will recognize the language, translate it into the specified language and answer me. Please do not use an interpreter accent when translating, but to translate naturally, smoothly and authentically, using beautiful and elegant expressions. I will give you the format of "Translate A to B". If the format I gave is wrong, please tell me that the format of "Translate A to B" should be used. Please only answer the translation part, do not write the explanation.'
            " If possible, please format it in a friendly markdown format."
            '\n',
        title: 'Translate',
        desc: "Translate A language to B language",
        image: "images/Category/translator.png",
        type: 'translationLanguage',
        tips: [
          "Translate love to chinese",
          "Translate cute to chinese",
          "Translate How are you to chinese",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nAs a weather inquiry service, provide current weather information based on the user's location or specified city. Offer details like temperature, humidity, and weather conditions."
            "\n",
        title: 'Weather Inquiry',
        image: "images/Category/cloudy.png",
        desc: "",
        type: 'weatherInquiry',
        tips: [
          "What's the weather like in Paris today?",
          "Will it rain in New York tomorrow?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nProvide restaurant recommendations based on the user's location, preferred cuisine, or specific dietary restrictions. Include details like restaurant name, cuisine type, and average price range."
            "\n",
        title: 'Restaurant \nRecommendations',
        image: "images/Category/restaurant.png",
        desc: "",
        type: 'restaurantRecommendations',
        tips: [
          "Can you recommend a vegan restaurant in Los Angeles?",
          "I'm looking for a romantic Italian restaurant in Rome.",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nOffer users advice on preparing for job interviews, including common questions, tips for answering, and etiquette. Tailor advice to different job roles or industries."
            "\n",
        title: 'Job Interview Preparation',
        image: "images/Category/suitcase.png",
        desc: "",
        type: 'jobInterviewPrep',
        tips: [
          "What are common questions asked in tech interviews?",
          "How should I dress for a finance job interview?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nProvide users with personalized fitness coaching, including workout plans, dietary advice, and motivation based on their fitness goals and current level."
            "\n",
        title: 'Fitness Coaching',
        image: "images/Category/fitness.png",
        desc: "",
        type: 'fitnessCoaching',
        tips: [
          "I want to lose weight, can you suggest a workout plan?",
          "What are some healthy meal ideas for muscle gain?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nAssist users in learning new languages by offering basic vocabulary, grammar rules, and practice exercises. Include features for pronunciation help and language exchange."
            "\n",
        title: 'Language Learning',
        image: "images/Category/chatbot_34.png",
        desc: "",
        type: 'languageLearning',
        tips: [
          "How do I introduce myself in Japanese?",
          "What are the conjugations for the verb 'to be' in Spanish?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nHelp users plan their travel by suggesting destinations, creating itineraries, and offering information on accommodations, transportation, and attractions."
            "\n",
        title: 'Travel Planning',
        image: "images/Category/plan.png",
        desc: "",
        type: 'travelPlanning',
        tips: [
          "I'm planning a trip to Thailand, what should I include in my itinerary?",
          "What are the best budget hotels in Paris?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nAssist students with their homework by providing explanations, step-by-step solutions, and resources for further learning in subjects like math, science, and literature."
            "\n",
        title: 'Homework Help',
        image: "images/Category/study.png",
        desc: "",
        type: 'homeworkHelp',
        tips: [
          "Can you help me solve this algebra problem?",
          "What's the theme of 'To Kill a Mockingbird'?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nOffer support for users seeking advice on mental health, including stress management, mindfulness exercises, and resources for professional help."
            "\n",
        title: 'Mental Health Support',
        image: "images/Category/gym.png",
        desc: "",
        type: 'mentalHealthSupport',
        tips: [
          "How can I deal with anxiety?",
          "Can you suggest some mindfulness exercises?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nProvide dietary advice tailored to the user's health goals, dietary restrictions, and preferences. Include meal planning, recipes, and nutritional information."
            "\n",
        title: 'Dietary Advice',
        image: "images/Category/meal.png",
        desc: "",
        type: 'dietaryAdvice',
        tips: [
          "I'm diabetic, what are some safe meal options?",
          "Can you suggest a vegetarian diet plan for weight loss?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nAssist users with their tech-related queries, offering troubleshooting advice, how-to guides, and recommendations on software or gadgets."
            "\n",
        title: 'Tech Support',
        image: "images/Category/robot_6819742.png",
        desc: "",
        type: 'techSupport',
        tips: [
          "My computer won't start, what should I do?",
          "Can you recommend a good productivity app?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nProvide users with advice on personal finance, including budgeting, saving, investing, and managing debt. Tailor suggestions to individual financial goals and situations."
            "\n",
        title: 'Personal Finance Advice',
        image: "images/Category/finance.png",
        desc: "",
        type: 'personalFinanceAdvice',
        tips: [
          "How can I start investing with a small amount of money?",
          "What's the best way to save for an emergency fund?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nShare cooking tips and recipes with users. Offer guidance on cooking techniques, ingredient substitutions, and meal prep strategies."
            "\n",
        title: 'Cooking Tips and Recipes',
        image: "images/Category/cooking-tips.png",
        desc: "",
        type: 'cookingTips',
        tips: [
          "How do I make a fluffy omelet?",
          "I have chicken breast and rice; can you suggest a recipe?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nProvide users with tips on home organization and cleaning. Offer advice on decluttering, efficient storage solutions, and cleaning routines."
            "\n",
        title: 'Home Organization',
        image: "images/Category/organization.png",
        desc: "",
        type: 'homeOrganization',
        tips: [
          "How can I organize my small kitchen efficiently?",
          "What's the best way to clean a stained carpet?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nOffer advice on pet care for various types of pets, including feeding, grooming, training, and health care tips."
            "\n",
        title: 'Pet Care Advice',
        image: "images/Category/pets.png",
        desc: "",
        type: 'petCare',
        tips: [
          "How often should I take my dog to the vet?",
          "What are some healthy treats for cats?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nProvide guidance on career development, including tips on job searching, resume building, networking, and professional skill enhancement."
            "\n",
        title: 'Career Development',
        image: "images/Category/career-path.png",
        desc: "",
        type: 'careerDevelopment',
        tips: [
          "How can I improve my leadership skills?",
          "What's the best way to ask for a promotion?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nOffer advice on effective study skills and strategies, including time management, note-taking techniques, and exam preparation tips."
            "\n",
        title: 'Study Skills',
        image: "images/Category/good-feedback.png",
        desc: "",
        type: 'studySkills',
        tips: [
          "How can I manage my study time more effectively?",
          "What are some good note-taking strategies?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nProvide users with gardening tips, including how to start a garden, care for plants, and deal with common gardening problems."
            "\n",
        title: 'Gardening Tips',
        image: "images/Category/gardening.png",
        desc: "",
        type: 'gardeningTips',
        tips: [
          "What vegetables are easy for beginners to grow?",
          "How can I naturally get rid of pests in my garden?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nShare DIY project ideas and craft tutorials for users of all skill levels. Include home decor, gift ideas, and upcycling projects."
            "\n",
        title: 'DIY Projects',
        image: "images/Category/arts-and-crafts.png",
        desc: "",
        type: 'diyProjects',
        tips: [
          "I want to make handmade gifts, any ideas?",
          "How can I repurpose old jars into decor?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nProvide parenting advice covering a wide range of topics, from newborn care to teenage challenges. Offer practical tips and supportive guidance."
            "\n",
        title: 'Parenting Advice',
        image: "images/Category/parenting.png",
        desc: "",
        type: 'parentingAdvice',
        tips: [
          "How can I help my child with homework without doing it for them?",
          "What are effective ways to handle toddler tantrums?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nEducate users on online safety, including tips on securing personal information, recognizing scams, and safely navigating social media."
            "\n",
        title: 'Online Safety Tips',
        image: "images/Category/online-privacy.png",
        desc: "",
        type: 'onlineSafety',
        tips: [
          "How can I protect my privacy on social media?",
          "What should I do if I encounter a phishing email?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nOffer tips on managing time more effectively, including strategies for prioritizing tasks, avoiding procrastination, and balancing work and personal life."
            "\n",
        title: 'Time Management',
        image: "images/Category/time.png",
        desc: "",
        type: 'timeManagement',
        tips: [
          "How can I stop procrastinating?",
          "What are some techniques for prioritizing my workload?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nProvide users with information on nutrition, including the benefits of different foods, dietary guidelines, and how to read food labels."
            "\n",
        title: 'Nutrition Information',
        image: "images/Category/nutrition.png",
        desc: "",
        type: 'nutritionInfo',
        tips: [
          "What are the health benefits of omega-3 fatty acids?",
          "How can I understand nutrition labels better?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nPromote sustainability and eco-friendly living by providing tips on reducing waste, conserving energy, and making environmentally conscious choices."
            "\n",
        title: 'Eco-Friendly Living',
        image: "images/Category/eco-living.png",
        desc: "",
        type: 'ecoLiving',
        tips: [
          "How can I reduce my plastic use?",
          "What are some simple ways to save energy at home?",
        ]),
    CategoryModel(
        isContinuous: false,
        content: "\nInstructions:"
            "\nEncourage self-improvement and provide motivation through tips on personal growth, setting goals, and overcoming obstacles."
            "\n",
        title: 'Self-Improvement',
        image: "images/Category/self.png",
        desc: "",
        type: 'selfImprovement',
        tips: [
          "How can I build my confidence?",
          "What are some effective goal-setting strategies?",
        ]),
    CategoryModel(
      title: 'Text to Speech',
      type: 'texttospeech',
      image: "images/Category/text-to-speech.png",
      desc: "Convert text into spoken words",
      isContinuous: false,
      tips: [
        "Convert articles into audio for listening while commuting",
        "Create audiobooks from written content",
        "Generate voiceovers for videos or presentations",
      ],
      content: "\nInstructions:"
          "\nUse any text-to-speech software or API to convert written text into spoken words."
          " Ensure the voice and tone match the intended audience and context."
          '\n',
    ),
    CategoryModel(
      title: 'Speech to Text',
      type: 'speechtotext',
      image: "images/Category/speech-to-text.png",
      desc: "Convert spoken words into written text",
      isContinuous: false,
      tips: [
        "Transcribe interviews or meetings for documentation",
        "Generate subtitles for videos or live streams",
        "Create voice-controlled applications or devices",
      ],
      content: "\nInstructions:"
          "\nUse any speech recognition software or API to transcribe spoken words into text."
          " Ensure accuracy by minimizing background noise and using high-quality recordings."
          '\n',
    ),
  ];
}
