module.exports = async function (context, req) {
  context.log('History request');
  const history = global.__GEN_HISTORY__ || [];
  context.res = {
    status: 200,
    body: { success: true, history }
  };
};
