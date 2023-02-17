const KEYPOINT_DICT = {
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

const EXERCISES = {
  'squats': {
    'name': 'Squat',
    'allowed_err': 15,
    'alert_err': 10,
    'states': [
      {
        ('both_knee,both_hip,both_ankle'): 100,
      },
      {
        ('both_knee,both_hip,both_ankle'): 180,
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
