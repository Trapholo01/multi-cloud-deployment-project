let history = global.__GEN_HISTORY__ || [];
global.__GEN_HISTORY__ = history;

async function callGoogleGemini(apiKey, model, promptText) {
  // Uses API key in query param; for production use OAuth2 Bearer tokens when appropriate.
  const modelPath = model || 'models/text-bison-001';
  const url = `https://generativelanguage.googleapis.com/v1beta2/${modelPath}:generate?key=${apiKey}`;
  const body = {
    prompt: { text: promptText },
    temperature: 0.2,
    maxOutputTokens: 512
  };

  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body)
  });
  const json = await res.json();
  // Try common response shapes
  if (json.candidates && json.candidates.length) return json.candidates[0].output || JSON.stringify(json);
  if (json.results && json.results.length && json.results[0].content) return json.results[0].content;
  if (json.output) return typeof json.output === 'string' ? json.output : JSON.stringify(json.output);
  return JSON.stringify(json);
}

async function callOpenAI(apiKey, model, promptText) {
  const url = 'https://api.openai.com/v1/chat/completions';
  const messages = [{ role: 'user', content: promptText }];
  const body = {
    model: model || 'gpt-4o-mini',
    messages,
    temperature: 0.2,
    max_tokens: 512
  };
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${apiKey}` },
    body: JSON.stringify(body)
  });
  const json = await res.json();
  if (json.choices && json.choices.length && json.choices[0].message) return json.choices[0].message.content;
  if (json.choices && json.choices.length && json.choices[0].text) return json.choices[0].text;
  return JSON.stringify(json);
}

module.exports = async function (context, req) {
  context.log('Received generation request');

  const body = req.body || {};
  const { type, data } = body;

  if (!type || !data) {
    context.res = {
      status: 400,
      body: { success: false, error: 'Type and data are required' }
    };
    return;
  }

  const geminiKey = process.env.GEMINI_API_KEY || process.env.GEMINI_KEY;
  const openaiKey = process.env.OPENAI_API_KEY;
  const geminiModel = process.env.GEMINI_MODEL; // optional
  const openaiModel = process.env.OPENAI_MODEL; // optional

  const promptText = typeof data === 'string' ? data : JSON.stringify(data);

  let generated;
  try {
    if (geminiKey) {
      context.log('Using Google Gemini (Generative Language) API');
      generated = await callGoogleGemini(geminiKey, geminiModel, `${type}: ${promptText}`);
    } else if (openaiKey) {
      context.log('Using OpenAI API');
      generated = await callOpenAI(openaiKey, openaiModel, `${type}: ${promptText}`);
    } else {
      context.log('No provider API key configured — returning mock response');
      generated = `MOCK: ${type} -> ${promptText}`;
    }
  } catch (err) {
    context.log('Provider call failed', err);
    context.res = { status: 502, body: { success: false, error: 'AI provider error', details: String(err) } };
    return;
  }

  const entry = {
    id: Date.now().toString(),
    type,
    data,
    result: generated,
    createdAt: new Date().toISOString()
  };

  history.unshift(entry);
  if (history.length > 100) history.length = 100;

  context.res = {
    status: 200,
    body: { success: true, result: generated, entry }
  };
};
