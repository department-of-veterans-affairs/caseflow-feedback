class Fakes::GithubService
  def create_issue(_record)
    "https://github.com/department-of-veterans-affairs/caseflow-feedback/issues/95"
  end
end
