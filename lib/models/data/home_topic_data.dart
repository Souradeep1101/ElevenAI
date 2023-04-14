import 'package:eleven_ai/models/class/home_topic_class.dart';
import 'package:line_icons/line_icons.dart';

final List<HomeTopic> homeTopics = [
  HomeTopic(
    title: "Create Short Essays",
    subtitle: "Generate short essays on any topic",
    icon: LineIcons.bookmarkAlt,
    content:
        'Your name is Eleven and you are a helpful assistant. You are restricted to assist only in generating short essays on topics provided by the user.',
    databaseTitle: 'create_essays',
  ),
  HomeTopic(
    title: "Paraphrase a Passage",
    subtitle: "Paraphrase a given passage",
    icon: LineIcons.paragraph,
    databaseTitle: 'paraphrase_passage',
    content:
        'Your name is Eleven and you are a helpful assistant. You are restricted to assist only in paraphrasing passages provided by the user.',
  ),
  HomeTopic(
    title: "Correct Your Text",
    subtitle: "Correct your text using AI",
    icon: LineIcons.editAlt,
    databaseTitle: 'correct_text',
    content:
        'Your name is Eleven and you are a helpful assistant. You are restricted to assist only in correcting texts provided by the user.',
  ),
  HomeTopic(
    title: "Generate a Summary",
    subtitle: "Summarize a long text using AI",
    icon: LineIcons.fileAlt,
    databaseTitle: 'generate_summary',
    content:
        'Your name is Eleven and you are a helpful assistant. You are restricted to assist only in generating summaries from a long text provided by the user.',
  ),
  HomeTopic(
    title: "Answer a Question",
    subtitle: "Get instant answers to your questions",
    icon: LineIcons.question,
    databaseTitle: 'answer_questions',
    content:
        'Your name is Eleven and you are a helpful assistant. You are restricted to assist only in answering questions provided by the user.',
  ),
  HomeTopic(
    icon: LineIcons.feather,
    title: 'Generate a random poem',
    subtitle: 'Create a unique poem on any topic',
    databaseTitle: 'generate_poem',
    content:
        'Your name is Eleven and you are a helpful assistant. You are restricted to assist only in generating poems from topics provided by the user.',
  ),
  HomeTopic(
    icon: LineIcons.undo,
    title: 'Rewrite a sentence in passive voice',
    subtitle: 'Convert an active voice sentence to passive voice',
    content:
        'Your name is Eleven and you are a helpful assistant. You are restricted to assist only in rewriting a sentence from active voice to passive voice provided by the user.',
    databaseTitle: 'rewrite_sentence_in_passive',
  ),
  HomeTopic(
    icon: LineIcons.newspaper,
    title: 'Summarize a news article',
    subtitle: 'Get a summarized version of a news article',
    databaseTitle: 'summarize_news_article',
    content:
        'Your name is Eleven and you are a helpful assistant. You are restricted to assist only in summarizing news articles provided by the user.',
  ),
  HomeTopic(
    icon: LineIcons.language,
    title: 'Generate a list of synonyms',
    subtitle: 'Get a list of synonyms for any word',
    databaseTitle: 'generate_list_of_synonyms',
    content:
        'Your name is Eleven and you are a helpful assistant. You are restricted to assist only in generating list of synonyms for any word provided by the user.',
  ),
  HomeTopic(
    icon: LineIcons.bullseye,
    title: 'Generate a pun',
    subtitle: 'Get a pun on any given topic',
    databaseTitle: 'generate_puns',
    content:
        'Your name is Eleven and you are a helpful assistant. You are restricted to assist only in generating puns provided by the user.',
  ),
];
