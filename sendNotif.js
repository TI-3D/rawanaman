const axios = require('axios');

const token = 'ya29.c.c0ASRK0GbXxUYPviDqLNSOP1bHL9L2gsVUff_kHo8u0IDGC_NhCfmHdnCHdlN5PKvCz7ICbfg8NDvClKZ7y4sRZvN47dryHGHLQCRNOZV4HtfFzQQ-gQNp3jHBSHPXr12cL85iCRmR53hq9wQZr5-9V1TKGwONHpebDm2E6MRPctANTVjhvK39ykfQZVHTUlge37Gp8QJIuYYq1jtvoA6VrDJ1WLwh3Ey9u3bQdyCEAVEHbAo26Oud-LjBiJR35eGjCyryF1pfkrh_DJS2h8UHSjunIj627w4Tb6Dy5Zx6xIY2L0f7KZhan4D4E8qLiZhl7_bR1b3uvUzVR6QPNUG0zF29ddBwexAjX9vIAMXTOEKKb1k6Ul4X0bML384A7qdUhcBvl8mmQOMo6dMRrZr8mz9cQ4JWrihh52UzwJakZj6Y1RydXOkJUxQ8nRv3pgd0kVa0ryicMpXhj9V7uigR64dypU_c53gx5luisk9uhZduOySdzjjS4jyBal07zh89fereZunjJdsYRgUQ82k7jS8ZvXwsSnt7emIftrbJept_5xiBzB1d67ffMfJhSIzQWRUqMglvI0yBRMqfcgaQxbbW6rRpIV3uwaa9szknr07x93ovzV-9Uoe1M2vl6Rtv77VwrVJ_YgekaYh2QerBJQR_pzth7b00ZbFFuRzqbmvld3aMOdthc-BMtaSYBc7fSbFfn3pYoU_hBmm_Jt169_YeB1OMuFVjMZxWcYBW1OJh3de2-YhWaw4xX0js7uJ_-ZXOg0fQ7Inj6n9BWjdrvOB566-JgwSySShBZdreVv1ljiFtbtdnFozMBZb-B_Isj0gJ4Bb4sbowY1FJjfSe9xnsk-BWb6ijdtotF49n3-9BJjWQQ6BYI-OpBx16qq758u7B3OnmZyxlU__UQfIzXSkorvQmOw4evcQ25BfndB_vg3aXgg-v9Vj_S0rz0eM-p1UY8vatargamBdieFV1nl221kioF7SOd9Uus94zjVkQOx5pB3BU0Xm'; // Replace with your generated token

const url = 'https://fcm.googleapis.com/v1/projects/rawanaman-8c43f/messages:send';

const messagePayload = {
  message: {
    // topic: "plant",
    token: 'fK08WKfmSPCEVNBcgUSiUb:APA91bG_DRf_bfzYH5I7kX1fKVZgM79gDHK7u-TVVIrm1JWnLdNY9sPvO_GUbPV8Ma-QzHYdO3DHl6Bx_EPOlD4kU8TSuP2T7ZhJeP28a8Nup7XFpwPBV_I',
    notification: {
      title: "Broadcast Notification",
      body: "This message is sent to all devices!"
    },
    data: {
      type: "plant" // Used for navigation
    },
    android: {
      priority: "high",
      notification: {
        channel_id: "high_importance_channel"
      }
    }
  }
};

const headers = {
  'Authorization': `Bearer ${token}`,
  'Content-Type': 'application/json'
};

axios.post(url, messagePayload, { headers })
  .then(response => {
    console.log('Message sent successfully:', response.data);
  })
  .catch(error => {
    console.error('Error sending message:', error.response ? error.response.data : error.message);
  });