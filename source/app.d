import jupyter.wire.kernel;
import jupyter.wire.message : CompleteResult;
import drepl;

mixin Main!DLangBackend;
typeof(interpreter(dmdEngine())) inpr;
static this() {
  inpr = interpreter(dmdEngine());
}

struct DLangBackend {
    enum languageInfo = LanguageInfo("D", "0.0.1", ".d");
    int value;
    ExecutionResult execute(in string code, scope IoPubMessageSender sender) {
        import std.conv: text;
	auto res = inpr.interpret(code);
	final switch (res.state) with(InterpreterResult.State)
        {
        case incomplete:
            break;

        case success:
        case error:
            if (res.stderr.length) return textResult(res.stderr);
            if (res.stdout.length) return textResult(res.stdout);
            break;
        }
	return textResult("");
    }
}
