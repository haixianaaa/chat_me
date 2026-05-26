import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/character.dart';
import '../models/chat_message.dart';
import '../models/chat_session.dart';
import '../services/ai_service.dart';
import '../services/storage_service.dart';

class ChatProvider extends ChangeNotifier {
  final AiService _aiService;
  final StorageService _storageService = StorageService();
  final _uuid = const Uuid();

  List<ChatSession> _sessions = [];
  ChatSession? _currentSession;
  bool _isLoading = false;
  String _streamingContent = '';

  List<ChatSession> get sessions => _sessions;
  ChatSession? get currentSession => _currentSession;
  bool get isLoading => _isLoading;
  String get streamingContent => _streamingContent;

  ChatProvider({required String apiKey, String baseUrl = 'https://api.xiaomimimo.com/v1', String model = 'mimo-v2-flash'})
      : _aiService = AiService(apiKey: apiKey, baseUrl: baseUrl, model: model);

  Future<void> init() async {
    // 先加载本地保存的 API 配置
    final apiKey = await _storageService.loadApiKey();
    final baseUrl = await _storageService.loadBaseUrl();
    final model = await _storageService.loadModel();
    if (apiKey.isNotEmpty) {
      _aiService.apiKey = apiKey;
      _aiService.baseUrl = baseUrl;
      _aiService.model = model;
    }
    _sessions = await _storageService.loadSessions();
    notifyListeners();
  }

  Future<void> updateApiConfig({
    required String apiKey,
    required String baseUrl,
    required String model,
  }) async {
    _aiService.apiKey = apiKey;
    _aiService.baseUrl = baseUrl;
    _aiService.model = model;
    await _storageService.saveApiKey(apiKey);
    await _storageService.saveBaseUrl(baseUrl);
    await _storageService.saveModel(model);
  }

  Future<String> loadApiKey() => _storageService.loadApiKey();
  Future<String> loadBaseUrl() => _storageService.loadBaseUrl();
  Future<String> loadModel() => _storageService.loadModel();

  void createSession(Character character) {
    // 查找该角色是否已有会话
    final existing = _sessions.where((s) => s.characterId == character.id).toList();
    if (existing.isNotEmpty) {
      // 已有会话，直接切换到该会话
      _currentSession = existing.first;
      notifyListeners();
      return;
    }

    final session = ChatSession(
      id: _uuid.v4(),
      characterId: character.id,
      characterName: character.name,
      characterAvatar: character.avatar,
    );
    // 添加角色的问候语
    if (character.greeting.isNotEmpty) {
      session.messages.add(ChatMessage(
        id: _uuid.v4(),
        content: character.greeting,
        isUser: false,
      ));
    }
    _sessions.insert(0, session);
    _currentSession = session;
    _saveSessions();
    notifyListeners();
  }

  void selectSession(ChatSession session) {
    _currentSession = session;
    notifyListeners();
  }

  Future<void> sendMessage(String content) async {
    if (_currentSession == null || content.trim().isEmpty) return;

    // 添加用户消息
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      content: content.trim(),
      isUser: true,
    );
    _currentSession!.messages.add(userMessage);
    _currentSession!.updatedAt = DateTime.now();
    _isLoading = true;
    _streamingContent = '';
    notifyListeners();

    // 构建 messages 列表
    final character = Character.defaults.firstWhere(
      (c) => c.id == _currentSession!.characterId,
      orElse: () => Character.defaults.first,
    );

    final apiMessages = <Map<String, String>>[
      {'role': 'system', 'content': character.systemPrompt},
    ];
    for (final msg in _currentSession!.messages) {
      apiMessages.add({
        'role': msg.isUser ? 'user' : 'assistant',
        'content': msg.content,
      });
    }

    // 流式接收 AI 回复
    String fullReply = '';
    await for (final chunk in _aiService.chat(messages: apiMessages)) {
      fullReply += chunk;
      _streamingContent = fullReply;
      notifyListeners();
    }

    // 添加 AI 回复消息
    final aiMessage = ChatMessage(
      id: _uuid.v4(),
      content: fullReply,
      isUser: false,
    );
    _currentSession!.messages.add(aiMessage);
    _currentSession!.updatedAt = DateTime.now();
    _isLoading = false;
    _streamingContent = '';
    _saveSessions();
    notifyListeners();
  }

  Future<void> deleteSession(String sessionId) async {
    _sessions.removeWhere((s) => s.id == sessionId);
    if (_currentSession?.id == sessionId) {
      _currentSession = _sessions.isNotEmpty ? _sessions.first : null;
    }
    _saveSessions();
    notifyListeners();
  }

  void _saveSessions() {
    _storageService.saveSessions(_sessions);
  }
}
