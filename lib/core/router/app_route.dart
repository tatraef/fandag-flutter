enum AppRoute {
  hikes('/hikes'),
  favorites('/favorites'),
  hikeDetail('/hike/:id'),
  organizer('/organizer/:id');

  const AppRoute(this.path);

  final String path;
}
