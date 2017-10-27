require "rails_helper"
require "pry"

RSpec.feature "Enter feedback" do
  before do
    reset_application!
  end

  scenario "Load Feedback page" do
    visit "/feedback/new"
    expect(page).to have_content("Tell us about your experience with Caseflow")
    expect(page).to have_content("Add your comments")
    expect(page).to have_content("Your comments will help us improve Caseflow for everyone.")
    expect(page).to have_content("Contact email")
    expect(page).to have_css("#feedback_feedback")
    page.should have_link("Cancel")
    fill_in "Add your comments", with: "Feedback"
    fill_in "If you are having an issue", with: "Veteran PII"
    fill_in "Contact email", with: "email@va.gov"
    click_on "Send Feedback"
    expect(page).to have_content("Thank you")
    expect(Feedback.last.feedback).to eq("Feedback")
    expect(Feedback.last.veteran_pii).to eq("Veteran PII")
    expect(Feedback.last.contact_email).to eq("email@va.gov")
    click_on "Send more feedback"
    expect(page).to have_content("Tell us about your experience with Caseflow")
    fill_in "Add your comments", with: "Feedback Text"
    fill_in "If you are having an issue", with: "Veteran PII Info"
    fill_in "Contact email", with: "fk@va.gov"
    click_on "Send Feedback"
    expect(Feedback.last.feedback).to eq("Feedback Text")
    expect(Feedback.last.veteran_pii).to eq("Veteran PII Info")
    expect(Feedback.last.contact_email).to eq("fk@va.gov")
    expect(page).to have_content("Thank you")
  end

  scenario "Validate Input Fields" do
    visit "/feedback/new"
    click_on "Send Feedback"
    expect(page).to have_content("Make sure you’ve filled out the comment box below.")
    expect(page).to have_content("Make sure you’ve entered a valid email address below.")
    fill_in "Add your comments", with: "     "
    click_on "Send Feedback"
    expect(page).to have_content("Make sure you’ve filled out the comment box below.")
    fill_in "Add your comments", with: "Feedback"
    fill_in "Contact email", with: "fk@va"
    click_on "Send Feedback"
    expect(page).not_to have_content("Make sure you’ve filled out the comment box below.")
    expect(page).to have_content("Make sure you’ve entered a valid email address below.")
    fill_in "Contact email", with: "fk@va.gov"
    click_on "Send Feedback"
    expect(page).not_to have_content("Make sure you’ve filled out the comment box below.")
    expect(page).not_to have_content("Make sure you’ve entered a valid email address below.")
  end

  scenario "Test Characters remaining" do
    visit "/feedback/new"
    expect(page).not_to have_content("characters remaining")
    fill_in "Add your comments", with: "Feedback"
    expect(page).to have_content("1992 characters remaining")
    fill_in "Add your comments", with:
        "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget
        dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur
        ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla
        consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu.
        In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede
        mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean
        vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac,
        enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra
        nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel
        augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus,
        tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque
        sedipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec
        odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis
        ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit
        amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue
        velit cursus nunc, quis gravida magna mi a libero. Fusce vulputate eleifend sapien.
        Vestibulum purus quam, scelerisque ut, mollis sed, nonummy id, metus. Nullam accumsan
        lorem in dui. Cras ultricies mi eu turpis hendrerit fringilla. Vestibulum ante ipsum
        primis in faucibus orci luctus et ultrices posuere cubilia Curae; In ac dui quis mi
        consectetuer lacinia. Nam pretium turpis et arcu. Duis arcu tortor, suscipit eget,
        imperdiet nec, imperdiet iaculis, ipsum. Sed aliquam ultrices mauris. Integer ante arcu,
        accumsan a, consectetuer eget, posuere ut, mauris. Praesent adipiscing. Phasellus
        ullamcorper ipsum rutrum nunc. Nunc nonummy metus. Vestib"
    expect(page).to have_content("0 characters remaining")
    fill_in "Add your comments", with:
        "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget
        dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur
        ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla
        consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu.
        In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede
        mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean
        vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac,
        enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra
        nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel
        augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus,
        tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque
        sedipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec
        odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis
        ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit
        amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue
        velit cursus nunc, quis gravida magna mi a libero. Fusce vulputate eleifend sapien.
        Vestibulum purus quam, scelerisque ut, mollis sed, nonummy id, metus. Nullam accumsan
        lorem in dui. Cras ultricies mi eu turpis hendrerit fringilla. Vestibulum ante ipsum
        primis in faucibus orci luctus et ultrices posuere cubilia Curae; In ac dui quis mi
        consectetuer lacinia. Nam pretium turpis et arcu. Duis arcu tortor, suscipit eget,
        imperdiet nec, imperdiet iaculis, ipsum. Sed aliquam ultrices mauris. Integer ante arcu,
        accumsan a, consectetuer eget, posuere ut, mauris. Praesent adipiscing. Phasellus
        ullamcorper ipsum rutrum nunc. Nunc nonummy metus. Vestib{"
    expect(page).to have_content("0 characters remaining")
    expect(page).not_to have_content("{")
  end
end
