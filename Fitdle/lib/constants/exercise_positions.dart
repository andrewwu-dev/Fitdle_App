const keyPointDict = {
  'nose': 0,
  'left_eye': 1,
  'right_eye': 2,
  'left_ear': 3,
  'right_ear': 4,
  'left_shoulder': 5,
  'right_shoulder': 6,
  'left_elbow': 7,
  'right_elbow': 8,
  'left_wrist': 9,
  'right_wrist': 10,
  'left_hip': 11,
  'right_hip': 12,
  'left_knee': 13,
  'right_knee': 14,
  'left_ankle': 15,
  'right_ankle': 16
};

const bothKeyPointDict = {
  'both_shoulder': [5, 6],
  'both_elbow': [7, 8],
  'both_wrist': [9, 10],
  'both_hip': [11, 12],
  'both_knee': [13, 14],
  'both_ankle': [15, 16]
};

const exercises = {
  'squats': {
    'name': 'Squat',
    'allowed_err': 10,
    'alert_err': 5,
    'states': [
      {
        ('both_knee,both_hip,both_ankle'): 180,
      },
      {
        ('both_knee,both_hip,both_ankle'): 90,
      }
    ]
  },
  'pushups': {
    'name': 'Pushup',
    'allowed_err': 25,
    'alert_err': 5,
    'states': [
      {
        'both_elbow,both_wrist,both_shoulder': 180,
        'both_hip,both_shoulder,both_ankle': 180,
      },
      {
        'both_elbow,both_wrist,both_shoulder': 90,
        'both_hip,both_shoulder,both_ankle': 180,
      }
    ]
  },
};

// Maps bones to a rbg color value
// rn theyre all the same colour (neon green) can change if needed
const keyPointsEdgeIndsToColor = {
  // [0, 1]: [57, 255, 20],
  // [0, 2]: [57, 255, 20],
  // [1, 3]: [57, 255, 20],
  // [2, 4]: [57, 255, 20],
  // [0, 5]: [57, 255, 20],
  // [0, 6]: [57, 255, 20],
  [5, 7]: [57, 255, 20],
  [7, 9]: [57, 255, 20],
  [6, 8]: [57, 255, 20],
  [8, 10]: [57, 255, 20],
  [5, 6]: [57, 255, 20],
  [5, 11]: [57, 255, 20],
  [6, 12]: [57, 255, 20],
  [11, 12]: [57, 255, 20],
  [11, 13]: [57, 255, 20],
  [13, 15]: [57, 255, 20],
  [12, 14]: [57, 255, 20],
  [14, 16]: [57, 255, 20]
};
