/// Enum representing metadata handling options
/// - [preserve]: Preserve all the existing metadata
/// - [delete]: Removes all metadata
enum Metadata { preserve, delete }

// TODO: Add more audio channels
/// Enum representing available audio channel options
/// - [unchanged]: Keep the audio channel as it is
/// - [mono]: Convert the audio to mono
/// - [stereo]: Convert the audio to stereo
enum AudioChannel { unchanged, mono, stereo }

int samplingRate = -1;
String format = 'mp3';
AudioChannel audioChannel = AudioChannel.unchanged;
Metadata metadata = Metadata.preserve;

