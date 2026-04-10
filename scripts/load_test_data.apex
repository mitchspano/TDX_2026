// Load Test Data for Job Posting Application
System.debug('Starting test data load...');

// Create Contacts (Candidates)
List<Contact> contacts = new List<Contact>{
  new Contact(
    FirstName = 'Sarah',
    LastName = 'Johnson',
    Email = 'sarah.johnson@email.com',
    Phone = '(555) 123-4567',
    Title = 'Senior Software Engineer'
  ),
  new Contact(
    FirstName = 'Michael',
    LastName = 'Chen',
    Email = 'michael.chen@email.com',
    Phone = '(555) 234-5678',
    Title = 'Product Manager'
  ),
  new Contact(
    FirstName = 'Emily',
    LastName = 'Rodriguez',
    Email = 'emily.rodriguez@email.com',
    Phone = '(555) 345-6789',
    Title = 'UX Designer'
  ),
  new Contact(
    FirstName = 'David',
    LastName = 'Patel',
    Email = 'david.patel@email.com',
    Phone = '(555) 456-7890',
    Title = 'Full Stack Developer'
  ),
  new Contact(
    FirstName = 'Jessica',
    LastName = 'Williams',
    Email = 'jessica.williams@email.com',
    Phone = '(555) 567-8901',
    Title = 'Marketing Manager'
  ),
  new Contact(
    FirstName = 'James',
    LastName = 'Thompson',
    Email = 'james.thompson@email.com',
    Phone = '(555) 678-9012',
    Title = 'DevOps Engineer'
  ),
  new Contact(
    FirstName = 'Lisa',
    LastName = 'Anderson',
    Email = 'lisa.anderson@email.com',
    Phone = '(555) 789-0123',
    Title = 'Sales Executive'
  ),
  new Contact(
    FirstName = 'Robert',
    LastName = 'Martinez',
    Email = 'robert.martinez@email.com',
    Phone = '(555) 890-1234',
    Title = 'Business Analyst'
  ),
  new Contact(
    FirstName = 'Amanda',
    LastName = 'Lee',
    Email = 'amanda.lee@email.com',
    Phone = '(555) 901-2345',
    Title = 'Customer Success Manager'
  ),
  new Contact(
    FirstName = 'Christopher',
    LastName = 'Brown',
    Email = 'christopher.brown@email.com',
    Phone = '(555) 012-3456',
    Title = 'Data Scientist'
  )
};
insert contacts;
System.debug('Inserted ' + contacts.size() + ' contacts');

// Create map for easy lookup
Map<String, Id> contactMap = new Map<String, Id>();
for (Contact c : contacts) {
  contactMap.put(c.Email, c.Id);
}

// Create Job Postings
List<Job_Posting__c> jobPostings = new List<Job_Posting__c>{
  new Job_Posting__c(
    ExternalId__c = 'JP-001',
    Title__c = 'Senior Software Engineer',
    Description__c = 'We are seeking an experienced Senior Software Engineer to join our Engineering team. You will be responsible for designing and implementing scalable solutions, mentoring junior developers, and driving technical excellence.',
    Department__c = 'Engineering',
    Location__c = 'San Francisco CA',
    Employment_Type__c = 'Full-Time',
    Salary_Range__c = '$150000-$180000',
    Posted_Date__c = Date.newInstance(2026, 1, 15),
    Closing_Date__c = Date.newInstance(2026, 4, 15),
    Status__c = 'Open',
    Number_of_Openings__c = 2
  ),
  new Job_Posting__c(
    ExternalId__c = 'JP-002',
    Title__c = 'Product Manager',
    Description__c = 'Looking for a strategic Product Manager to lead our product roadmap and work closely with engineering and design teams. Must have 5+ years of experience in SaaS products.',
    Department__c = 'Engineering',
    Location__c = 'Remote',
    Employment_Type__c = 'Full-Time',
    Salary_Range__c = '$130000-$160000',
    Posted_Date__c = Date.newInstance(2026, 2, 1),
    Closing_Date__c = Date.newInstance(2026, 4, 30),
    Status__c = 'Open',
    Number_of_Openings__c = 1
  ),
  new Job_Posting__c(
    ExternalId__c = 'JP-003',
    Title__c = 'UX Designer',
    Description__c = 'Creative UX Designer needed to craft intuitive user experiences. You will collaborate with product and engineering to design user-centered solutions.',
    Department__c = 'Marketing',
    Location__c = 'New York NY',
    Employment_Type__c = 'Full-Time',
    Salary_Range__c = '$90000-$120000',
    Posted_Date__c = Date.newInstance(2026, 1, 20),
    Closing_Date__c = Date.newInstance(2026, 3, 31),
    Status__c = 'Open',
    Number_of_Openings__c = 1
  ),
  new Job_Posting__c(
    ExternalId__c = 'JP-004',
    Title__c = 'DevOps Engineer',
    Description__c = 'Join our infrastructure team as a DevOps Engineer. Build and maintain CI/CD pipelines, manage cloud infrastructure, and ensure high availability.',
    Department__c = 'Engineering',
    Location__c = 'Austin TX',
    Employment_Type__c = 'Full-Time',
    Salary_Range__c = '$120000-$150000',
    Posted_Date__c = Date.newInstance(2026, 2, 10),
    Closing_Date__c = Date.newInstance(2026, 5, 10),
    Status__c = 'Open',
    Number_of_Openings__c = 2
  ),
  new Job_Posting__c(
    ExternalId__c = 'JP-005',
    Title__c = 'Marketing Manager',
    Description__c = 'Experienced Marketing Manager to lead our marketing campaigns and grow brand awareness. B2B SaaS experience preferred.',
    Department__c = 'Marketing',
    Location__c = 'Boston MA',
    Employment_Type__c = 'Full-Time',
    Salary_Range__c = '$100000-$130000',
    Posted_Date__c = Date.newInstance(2026, 1, 25),
    Closing_Date__c = Date.newInstance(2026, 4, 25),
    Status__c = 'Open',
    Number_of_Openings__c = 1
  ),
  new Job_Posting__c(
    ExternalId__c = 'JP-006',
    Title__c = 'Sales Executive',
    Description__c = 'Driven Sales Executive to join our growing sales team. You will prospect new clients and close deals in the enterprise segment.',
    Department__c = 'Sales',
    Location__c = 'Chicago IL',
    Employment_Type__c = 'Full-Time',
    Salary_Range__c = '$80000-$100000 + Commission',
    Posted_Date__c = Date.newInstance(2026, 2, 5),
    Closing_Date__c = Date.newInstance(2026, 5, 5),
    Status__c = 'Open',
    Number_of_Openings__c = 3
  ),
  new Job_Posting__c(
    ExternalId__c = 'JP-007',
    Title__c = 'Data Scientist',
    Description__c = 'Data Scientist with strong ML/AI background to analyze data and build predictive models. Python and SQL expertise required.',
    Department__c = 'Engineering',
    Location__c = 'San Francisco CA',
    Employment_Type__c = 'Full-Time',
    Salary_Range__c = '$140000-$170000',
    Posted_Date__c = Date.newInstance(2026, 2, 15),
    Closing_Date__c = Date.newInstance(2026, 5, 15),
    Status__c = 'Open',
    Number_of_Openings__c = 1
  ),
  new Job_Posting__c(
    ExternalId__c = 'JP-008',
    Title__c = 'Customer Success Manager',
    Description__c = 'Customer Success Manager to ensure client satisfaction and drive product adoption. SaaS experience a plus.',
    Department__c = 'Customer Success',
    Location__c = 'Remote',
    Employment_Type__c = 'Full-Time',
    Salary_Range__c = '$85000-$110000',
    Posted_Date__c = Date.newInstance(2026, 1, 10),
    Closing_Date__c = Date.newInstance(2026, 3, 15),
    Status__c = 'Closed',
    Number_of_Openings__c = 1
  ),
  new Job_Posting__c(
    ExternalId__c = 'JP-009',
    Title__c = 'Full Stack Developer Intern',
    Description__c = 'Summer internship opportunity for Full Stack Developers. Great learning experience with mentorship from senior engineers.',
    Department__c = 'Engineering',
    Location__c = 'San Francisco CA',
    Employment_Type__c = 'Internship',
    Salary_Range__c = '$25-$35 per hour',
    Posted_Date__c = Date.newInstance(2026, 3, 1),
    Closing_Date__c = Date.newInstance(2026, 4, 1),
    Status__c = 'Draft',
    Number_of_Openings__c = 2
  ),
  new Job_Posting__c(
    ExternalId__c = 'JP-010',
    Title__c = 'Business Analyst',
    Description__c = 'Business Analyst to work with stakeholders and translate business requirements into technical specifications.',
    Department__c = 'Operations',
    Location__c = 'Seattle WA',
    Employment_Type__c = 'Contract',
    Salary_Range__c = '$90000-$115000',
    Posted_Date__c = Date.newInstance(2026, 2, 20),
    Closing_Date__c = Date.newInstance(2026, 5, 20),
    Status__c = 'On Hold',
    Number_of_Openings__c = 1
  )
};
insert jobPostings;
System.debug('Inserted ' + jobPostings.size() + ' job postings');

// Create map for easy lookup
Map<String, Id> jobPostingMap = new Map<String, Id>();
for (Job_Posting__c jp : jobPostings) {
  jobPostingMap.put(jp.ExternalId__c, jp.Id);
}

// Create Job Applications
List<Job_Application__c> applications = new List<Job_Application__c>{
  new Job_Application__c(
    Job_Posting__c = jobPostingMap.get('JP-001'),
    Candidate__c = contactMap.get('sarah.johnson@email.com'),
    Application_Date__c = Date.newInstance(2026, 1, 20),
    Status__c = 'Interview',
    Years_of_Experience__c = 8,
    Resume_URL__c = 'https://resume.example.com/sarah-johnson',
    Cover_Letter__c = 'I am excited to apply for the Senior Software Engineer position. With 8 years of experience in building scalable systems, I believe I would be a great fit for your team.'
  ),
  new Job_Application__c(
    Job_Posting__c = jobPostingMap.get('JP-001'),
    Candidate__c = contactMap.get('david.patel@email.com'),
    Application_Date__c = Date.newInstance(2026, 1, 22),
    Status__c = 'Under Review',
    Years_of_Experience__c = 5,
    Resume_URL__c = 'https://resume.example.com/david-patel',
    Cover_Letter__c = 'As a Full Stack Developer with 5 years of experience, I am eager to take on senior-level challenges and contribute to your engineering excellence.'
  ),
  new Job_Application__c(
    Job_Posting__c = jobPostingMap.get('JP-002'),
    Candidate__c = contactMap.get('michael.chen@email.com'),
    Application_Date__c = Date.newInstance(2026, 2, 3),
    Status__c = 'Offer Extended',
    Years_of_Experience__c = 7,
    Resume_URL__c = 'https://resume.example.com/michael-chen',
    Cover_Letter__c = 'With 7 years of product management experience in SaaS, I am confident I can drive your product strategy forward.'
  ),
  new Job_Application__c(
    Job_Posting__c = jobPostingMap.get('JP-003'),
    Candidate__c = contactMap.get('emily.rodriguez@email.com'),
    Application_Date__c = Date.newInstance(2026, 1, 25),
    Status__c = 'Phone Screen',
    Years_of_Experience__c = 4,
    Resume_URL__c = 'https://resume.example.com/emily-rodriguez',
    Cover_Letter__c = 'I am passionate about creating user-centered designs and would love to bring my 4 years of UX experience to your team.'
  ),
  new Job_Application__c(
    Job_Posting__c = jobPostingMap.get('JP-004'),
    Candidate__c = contactMap.get('james.thompson@email.com'),
    Application_Date__c = Date.newInstance(2026, 2, 12),
    Status__c = 'New',
    Years_of_Experience__c = 6,
    Resume_URL__c = 'https://resume.example.com/james-thompson',
    Cover_Letter__c = 'DevOps is my passion. With 6 years of experience managing cloud infrastructure and CI/CD pipelines, I am ready to contribute.'
  ),
  new Job_Application__c(
    Job_Posting__c = jobPostingMap.get('JP-005'),
    Candidate__c = contactMap.get('jessica.williams@email.com'),
    Application_Date__c = Date.newInstance(2026, 1, 28),
    Status__c = 'Interview',
    Years_of_Experience__c = 6,
    Resume_URL__c = 'https://resume.example.com/jessica.williams@email.com',
    Cover_Letter__c = 'As a Marketing Manager with B2B SaaS experience, I have successfully led campaigns that increased brand awareness by 40%.'
  ),
  new Job_Application__c(
    Job_Posting__c = jobPostingMap.get('JP-006'),
    Candidate__c = contactMap.get('lisa.anderson@email.com'),
    Application_Date__c = Date.newInstance(2026, 2, 8),
    Status__c = 'Offer Accepted',
    Years_of_Experience__c = 5,
    Resume_URL__c = 'https://resume.example.com/lisa-anderson',
    Cover_Letter__c = 'I am thrilled about this Sales Executive opportunity. My track record includes closing $2M+ in enterprise deals annually.'
  ),
  new Job_Application__c(
    Job_Posting__c = jobPostingMap.get('JP-006'),
    Candidate__c = contactMap.get('robert.martinez@email.com'),
    Application_Date__c = Date.newInstance(2026, 2, 6),
    Status__c = 'Under Review',
    Years_of_Experience__c = 4,
    Resume_URL__c = 'https://resume.example.com/robert-martinez',
    Cover_Letter__c = 'With my business analysis background and sales acumen, I believe I can excel in this sales role.'
  ),
  new Job_Application__c(
    Job_Posting__c = jobPostingMap.get('JP-007'),
    Candidate__c = contactMap.get('christopher.brown@email.com'),
    Application_Date__c = Date.newInstance(2026, 2, 18),
    Status__c = 'New',
    Years_of_Experience__c = 3,
    Resume_URL__c = 'https://resume.example.com/christopher-brown',
    Cover_Letter__c = 'Data Scientist with expertise in Python, ML/AI, and statistical modeling. Eager to build predictive models for your platform.'
  ),
  new Job_Application__c(
    Job_Posting__c = jobPostingMap.get('JP-008'),
    Candidate__c = contactMap.get('amanda.lee@email.com'),
    Application_Date__c = Date.newInstance(2026, 1, 12),
    Status__c = 'Rejected',
    Years_of_Experience__c = 5,
    Resume_URL__c = 'https://resume.example.com/amanda-lee',
    Cover_Letter__c = 'Customer success is where I thrive. I have helped SaaS companies achieve 95% retention rates through proactive engagement.'
  ),
  new Job_Application__c(
    Job_Posting__c = jobPostingMap.get('JP-001'),
    Candidate__c = contactMap.get('james.thompson@email.com'),
    Application_Date__c = Date.newInstance(2026, 1, 23),
    Status__c = 'Rejected',
    Years_of_Experience__c = 6,
    Resume_URL__c = 'https://resume.example.com/james-thompson',
    Cover_Letter__c = 'While my primary expertise is DevOps, I have strong software engineering fundamentals and would love to transition to this role.'
  ),
  new Job_Application__c(
    Job_Posting__c = jobPostingMap.get('JP-004'),
    Candidate__c = contactMap.get('david.patel@email.com'),
    Application_Date__c = Date.newInstance(2026, 2, 14),
    Status__c = 'Phone Screen',
    Years_of_Experience__c = 5,
    Resume_URL__c = 'https://resume.example.com/david-patel',
    Cover_Letter__c = 'My full-stack development experience has given me strong DevOps skills. I am excited about this infrastructure-focused role.'
  ),
  new Job_Application__c(
    Job_Posting__c = jobPostingMap.get('JP-002'),
    Candidate__c = contactMap.get('robert.martinez@email.com'),
    Application_Date__c = Date.newInstance(2026, 2, 2),
    Status__c = 'Withdrawn',
    Years_of_Experience__c = 4,
    Resume_URL__c = 'https://resume.example.com/robert-martinez',
    Cover_Letter__c = 'I am interested in transitioning from business analysis to product management and believe this role would be perfect.'
  ),
  new Job_Application__c(
    Job_Posting__c = jobPostingMap.get('JP-007'),
    Candidate__c = contactMap.get('sarah.johnson@email.com'),
    Application_Date__c = Date.newInstance(2026, 2, 17),
    Status__c = 'Under Review',
    Years_of_Experience__c = 8,
    Resume_URL__c = 'https://resume.example.com/sarah-johnson',
    Cover_Letter__c = 'While my background is in software engineering, I have been working with data science tools and am excited about this opportunity.'
  ),
  new Job_Application__c(
    Job_Posting__c = jobPostingMap.get('JP-005'),
    Candidate__c = contactMap.get('emily.rodriguez@email.com'),
    Application_Date__c = Date.newInstance(2026, 1, 30),
    Status__c = 'New',
    Years_of_Experience__c = 4,
    Resume_URL__c = 'https://resume.example.com/emily-rodriguez',
    Cover_Letter__c = 'As a UX Designer, I understand user behavior deeply and believe I can bring valuable insights to your marketing efforts.'
  )
};
insert applications;
System.debug('Inserted ' + applications.size() + ' job applications');

System.debug('Test data load complete!');
System.debug('Summary:');
System.debug('- Contacts: ' + contacts.size());
System.debug('- Job Postings: ' + jobPostings.size());
System.debug('- Job Applications: ' + applications.size());
