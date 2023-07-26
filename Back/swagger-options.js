// swagger options
const options = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: "Music-Player",
      version: "1.0.0",
      description: "API-Documentation",
    },
    components: {
      securitySchemes: {
        bearerAuth: {
          type: "apiKey",
          name: "Authorization",
          in: "header",
          description:
            "Enter your bearer token in the format 'Bearer &lt;token&gt;'",
        },
      },
    },
    security: [
      {
        bearerAuth: ["Bearer"],
      },
    ],
  },
  apis: ["./routes/*.js"],
};

module.exports = options;
