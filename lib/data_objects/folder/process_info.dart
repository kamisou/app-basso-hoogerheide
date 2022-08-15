class ProcessInfo {
  const ProcessInfo({
    required this.nature,
    required this.color,
    this.number,
    this.protocolDate,
    this.district,
    this.division,
  });

  final String nature;

  final int color;

  // TODO: procurador (obrigatório, será relacionado com conta)

  final int? number;

  final DateTime? protocolDate;

  final String? district;

  final String? division;

  // TODO: status? (localização no site, pode ser que vincule com as notas)
}
