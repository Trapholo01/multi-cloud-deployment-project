module.exports = async function (context, req) {
  context.log('Health check');
  context.res = {
    status: 200,
    body: {
      status: '✅ Server is running successfully',
      aiProvider: 'Google Gemini',
      timestamp: new Date().toISOString(),
      message: 'Backend API is working!'
    }
  };
};
