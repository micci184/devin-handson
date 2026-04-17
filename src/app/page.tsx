const HomePage = () => {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center gap-8 bg-background text-foreground">
      <h1 className="text-4xl font-bold">Devin Task Board</h1>

      <div className="flex flex-wrap justify-center gap-4">
        <button className="rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground">
          Primary
        </button>
        <button className="rounded-md bg-secondary px-4 py-2 text-sm font-medium text-secondary-foreground">
          Secondary
        </button>
        <button className="rounded-md bg-success px-4 py-2 text-sm font-medium text-success-foreground">
          Success
        </button>
        <button className="rounded-md bg-warning px-4 py-2 text-sm font-medium text-warning-foreground">
          Warning
        </button>
        <button className="rounded-md bg-danger px-4 py-2 text-sm font-medium text-danger-foreground">
          Danger
        </button>
        <button className="rounded-md border border-border bg-card px-4 py-2 text-sm font-medium text-card-foreground">
          Card
        </button>
        <button className="rounded-md bg-muted px-4 py-2 text-sm font-medium text-muted-foreground">
          Muted
        </button>
        <button className="rounded-md bg-accent px-4 py-2 text-sm font-medium text-accent-foreground">
          Accent
        </button>
      </div>

      <p className="text-sm text-muted-foreground">
        html に <code className="rounded bg-muted px-1 py-0.5">.dark</code>{" "}
        クラスを付与するとダークモードに切り替わります
      </p>
    </div>
  );
};
export default HomePage;
