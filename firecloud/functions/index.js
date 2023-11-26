/* eslint-disable no-unused-vars */
/* eslint-disable camelcase */
/* eslint-disable max-len */
const functions = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.sendNotification = functions.firestore
    .document("/users/{userId}/notifications/{notificationId}")
    .onWrite((snapshots, context) => {
        const data = snapshots.after.data();
        const userId = context.params.userId;
        const notificationId = context.params.notificationId;

        admin
            .firestore()
            .collection("users")
            .doc(userId)
            .get()
            .then((user) => {
                const userData = user.data();
                console.log(userData);
                const tokenId = userData["deviceToken"];
                admin
                    .messaging()
                    .send({
                        notification: {
                            title: data['title'],
                            body: data['body'],
                        }, data: { notificationId: notificationId }, token: tokenId
                    })
                    .then((response) => {
                        console.log("notification sent successfully");
                    })
                    .catch((error) => {
                        console.log("Error in on send message", error);
                    });
            })
            .catch((error) => {
                console.log("Error in on get device token", error);
            });
    });




