abstract class UseCase<Output, Params> {
  const UseCase();

  Future<Output> call(Params params);
}
