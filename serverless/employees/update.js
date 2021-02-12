"use strict";

const AWS = require("aws-sdk"); // eslint-disable-line import/no-extraneous-dependencies

const dynamoDb = new AWS.DynamoDB.DocumentClient();

module.exports.update = (event, context, callback) => {
  const timestamp = new Date().getTime();
  const data = JSON.parse(event.body);
  const { nome, cargo, idade } = data;
  console.log(event.pathParameters.id);

  if (
    typeof nome !== "string" ||
    typeof cargo !== "string" ||
    typeof idade !== "number"
  ) {
    console.error("Validation Failed");
    callback(null, {
      statusCode: 400,
      headers: { "Content-Type": "text/plain" },
      body: "Couldn't update the employee",
    });
    return;
  }

  const params = {
    TableName: process.env.DYNAMODB_TABLE,
    Key: {
      Id: event.pathParameters.id,
    },
    ExpressionAttributeValues: {
      ":Nome": nome,
      ":Cargo": cargo,
      ":Idade": idade,
      ":updatedAt": timestamp,
    },
    UpdateExpression:
      "SET Nome = :Nome, Cargo = :Cargo, Idade = :Idade, updatedAt = :updatedAt",
    ReturnValues: "ALL_NEW",
  };

  dynamoDb.update(params, (error, result) => {
    if (error) {
      console.error(error);
      callback(null, {
        statusCode: error.statusCode || 501,
        headers: { "Content-Type": "text/plain" },
        body: "Couldn't fetch the employee",
      });
      return;
    }

    const response = {
      statusCode: 200,
      body: JSON.stringify(result.Attributes),
    };
    callback(null, response);
  });
};
