enum RegistrationEventType {
  funMatch,
  clubOnly,
}

extension RegistrationEventTypeLabel on RegistrationEventType {
  String get label {
    switch (this) {
      case RegistrationEventType.funMatch:
        return 'Fun match untuk umum';
      case RegistrationEventType.clubOnly:
        return 'Kegiatan khusus club';
    }
  }
}
