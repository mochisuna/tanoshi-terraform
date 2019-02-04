'use strict';

exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request;
  const uri = request.uri;
  console.log(uri);
  request.uri = uri.replace(/\/$/, '\/index.html');

  callback(null, request);
};
