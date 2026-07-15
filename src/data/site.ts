/**
 * Single source of truth for site content sourced from the church's content
 * doc. Edit here (not in page files) when service times, staff, ministries,
 * or contact details change.
 */

export const site = {
  name: 'Christ Central East Bay',
  shortName: 'CCEB',
  tagline: 'A Place to Belong, Believe, and Become',
  subtext:
    'We are a Christ-centered community passionate about loving God, serving others, and growing together in faith.',
  welcome:
    'Whether you’ve been following Jesus for years or you’re just starting to explore faith, you are welcome here. At Christ Central East Bay, you’ll find a community of real people growing together, supporting one another, and discovering God’s purpose for our lives.',
  description:
    'Christ Central East Bay is a Christ-centered church community in Berkeley, CA. Join us Sundays at 10am — kids programs available.',
} as const;

export const service = {
  day: 'Sunday',
  time: '10:00 AM',
  address: '1821 Catalina Ave, Berkeley, CA',
  mapsUrl: 'https://maps.google.com/?q=1821+Catalina+Ave,+Berkeley,+CA',
  kidsNote: 'Kids programs available!',
  refreshmentsNote: 'Light refreshments are offered before and after service.',
  parkingNote: 'There should be plenty of street parking around the church.',
  locationNote: 'We are located in the main sanctuary.',
} as const;

export const contact = {
  email: 'office@christcentraleastbay.com',
  socialHandle: '@Christcentraleastbay',
  instagramUrl: 'https://www.instagram.com/christcentraleastbay',
} as const;

export const links = {
  christCentralSF: 'http://christcentralsf.com',
  westminsterStandards: 'https://westminsterstandards.org/',
} as const;

export const mission =
  'In humble reliance upon the grace of our Lord, we are committed to worshiping God, making disciples, and serving the body of Christ.';

export const story =
  'Christ Central East Bay was commissioned in 2026 as a church plant of Christ Central Presbyterian Church and the North America Presbytery West (KAPC). As members of the Korean-American Presbyterian Church, we subscribe to the Westminster Standards.';

export const values = [
  { name: 'Worship', blurb: 'Trusting God in all things' },
  { name: 'Community', blurb: 'Doing life together' },
  { name: 'Growth', blurb: 'Becoming more like Christ' },
  { name: 'Service', blurb: 'Loving others through action' },
  { name: 'Church Planting', blurb: 'Spreading the Gospel' },
] as const;

export const staff = [
  { role: 'Pastors', people: ['Simon Yang', 'Tony Chang'] },
  { role: 'Directors', people: ['Eunsook Park', 'Grace Sui'] },
  { role: 'Elder', people: ['Billy Kim'] },
  {
    role: 'Ordained Deacons',
    people: [
      'Brian Kim',
      'Dan Ha',
      'James Won',
      'Rob Hoang',
      'Sam Lee',
      'Sammy Pak',
      'William Wong',
      'Tommy Lee',
      'Sam Min',
    ],
  },
  {
    role: 'Deacons',
    people: [
      'Christine Lee',
      'Hamee Ha',
      'Katrina Kim',
      'Luxi Choi',
      'Minji Lee',
      'Loriann Song',
      'Suddie Choi',
    ],
  },
] as const;

export const ministries = [
  {
    name: 'Kids Ministry',
    blurb:
      'A fun and safe environment where children learn about God in an engaging way.',
  },
  {
    name: 'Youth Ministry',
    blurb:
      'A place for students to connect, grow, and discover their identity in Christ.',
  },
  {
    name: 'FiCB',
    fullName: 'Fellowship in Christ Berkeley',
    blurb:
      'Our college ministry exists to help students deepen their faith in Christ.',
  },
  {
    name: 'Community Groups',
    blurb:
      'Build friendships and grow spiritually in a smaller, more personal setting.',
  },
  {
    name: 'Outreach',
    blurb: 'Serving our community and beyond with compassion and purpose.',
  },
] as const;

export const nav = [
  { label: 'About', href: '/about' },
  { label: "I'm New", href: '/im-new' },
  { label: 'Connect', href: '/connect' },
  { label: 'Resources', href: '/#resources' },
  { label: 'Contact', href: '/#contact' },
] as const;
