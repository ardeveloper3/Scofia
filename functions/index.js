// Import required modules
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// Function to send a notification for a reminder
exports.sendScheduledNotification = functions.pubsub
    .schedule("* * * * *") // Every minute
    .timeZone("Asia/Dhaka") // Set your timezone to Bangladesh/Dhaka
    .onRun(async (context) => {
      const now = new Date(); // Current time
      const tasksRef = admin.firestore().collection("tasks");

      // Query tasks that should be sent now
      const tasksSnapshot = await tasksRef
          .where("startTime", "<=", now.toISOString())
          .get();

      // Iterate over each task
      tasksSnapshot.forEach(async (taskDoc) => {
        const task = taskDoc.data();
        const payload = {
          notification: {
            title: task.title,
            body: task.description,
          },
          data: {
            taskId: taskDoc.id, // Send document ID or any other data
          },
        };

        // Get user device tokens for the notification
        const usersRef = admin.firestore().collection("users");
        const userSnapshot = await usersRef.get();

        const tokens = [];
        userSnapshot.forEach((userDoc) => {
          const userData = userDoc.data();
          if (userData.deviceToken) {
            tokens.push(userData.deviceToken);
          }
        });

        // Send notification to all user device tokens
        if (tokens.length > 0) {
          try {
            await admin.messaging().sendToDevice(tokens, payload);
            console.log(`Notification sent for task: ${task.title}`);
          } catch (error) {
            console.error("Error sending notification:", error);
          }
        }
      });

      return null;
    });
