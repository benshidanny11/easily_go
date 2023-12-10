/* eslint-disable no-unused-vars */
/* eslint-disable camelcase */
/* eslint-disable max-len */
const functions = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.sendNotification = functions.firestore
    .document("/users/{userId}/notifications/{notificationId}")
    .onCreate(async (snapshots, context) => {
        //    console.log(`Notification data===========++++++=>>>>>>${snapshots.after.data()}`);
        let data;
        const userId = context.params.userId;
        const notificationId = context.params.notificationId;
        if (snapshots.exists) {
            data = snapshots.data();
            // Your code here
        } else {
            console.log('Document does not exist');
        }

        return admin
            .firestore()
            .collection("users")
            .doc(userId)
            .get()
            .then((user) => {
                const userData = user.data();
                console.log(userData);
                const tokenId = userData["deviceToken"];
                return admin
                    .messaging()
                    .send({
                        notification: {
                            title: data['title'],
                            body: data['body'],
                        }, data: { notificationId: notificationId, notificationType: data['notificationType'] }, token: tokenId
                    })
                    .then((response) => {
                        console.log("notification sent successfully");
                        return;
                    })
                    .catch((error) => {
                        console.log("Error in on send message", error);
                        return;
                    });
            })
            .catch((error) => {
                console.log("Error in on get device token", error);
                return;
            });
    });




