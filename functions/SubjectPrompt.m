function sub = SubjectPrompt ()
  % Collect subject information.
  prompt = {'Subject Code'};
  default = {'1'};
  input = inputdlg(prompt, 'Enter Subject Information', 1, default);

  if length(input) == length(prompt)
    sub = input{1};
  else
    return;
  end
end