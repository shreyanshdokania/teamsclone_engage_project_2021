LEARNINGS :

- Learned how to use real time connection APIs such as webRTC APIs , SDKs like Agora , Azure Communication Services and jitsi_meet sdk . Got to know how to properly thread APIs - together and get a real time connection working for the end users and also with a better integration of it with the UI component for the best user experience.
- Got to know about Agile methodology and its real implementation use case and how to plan , design , build and test the prototype within the sprints.
- Practiced and learned a lot of different queries and search algorithms for Cloud Firestore with Flutter.
- Used different dependencies/libraries for implementing different kinds of features starting from the very basics like showing a small toaster to building something like FingerPrint and FaceID authentication on top of Google Sign In.
- Learned how to implement fast and efficient searches integrated with UI and presenting everything in real time.
- Practiced a lot of Firebase Could Firestore queries in terms of multilevel collections and documents integrated with each other.
- Figured out how to implement a real time speech to text translation algorithm with the use of some dependencies keeping the UI minimalist and clean.
- Learned to separate the business logic and UI code as much as possible for the code to be understandable and clean, minimizing code duplication ultimately resulting in better performance.


CHALLENGES => HOW I OVERCAME THEM :

- The very first challenge I faced was implementing a real time video communication feature where I ran into a lot of errors and if working then bugs.
  
  --> Finally after reading through the Documentations and trying and testing out the code on different devices , I was able to make multiple nodes connect over the network for a real time audio and video call with simultaneous chat.
- Secondly, handling edge cases in different scripts was a big challenge , such as making sure that only the user having a sensor should be prompted to the authentication page for fingerprint or face ID and many different edge cases for the database entries.

  --> Testing out the application on different devices while making changes in the required changes in the codebase resolved the issues.
- Passing the appropriate data between different pages avoiding any memory leaks and overconsumption of memory or space seemed to have issues as at some places like scheduling a meeting and creating an after chat was having some bugs because of improper flags used.

  --> Reading through some threads and debugging the application resulted in solving the bugs.
- Finally making sure there are no known bugs for the features implemented for the end user to have a seamless experience was the biggest challenge.

  --> Continuous debugging and refining the scripts I was able to manage to fix every known bug (both the UI glitches or backend code suspensions).


FUTURE SCOPE (What I would have implemented if got more time):

The very first thing is that, whatever I was building , I wanted to apply everything I know and everything I learned during the development phase in the most efficient way.

- Talking about future scope, I would like to implement push notifications managed by the developer from the Firebase Console with different AI predictions for specific users.

- I would also like to enhance the searching algorithm using pattern matching algorithms and with use of more appropriate data structures throughout the application.

- There’s a lot to implement but finally I would like to work more on the security part for the users data protection (also including many more login APIs such as Microsoft and Facebook login).

INTERESTING AND MOST IMPORTANT FEATURES(according to me ) :

- Interesting :
  
  --> The speech to text and fingerprint and faceID authentication features seemed the most interesting to me as they are not the most traditional ones.
- Important :
  
  --> Scheduling a meeting and creating before and after chats.
  
  --> Mailing the members notifying about the start of an instant meeting (if the host wants to).
  
  --> Separate chat functionality for the users.
	
