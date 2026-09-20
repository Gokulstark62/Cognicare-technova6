import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final family = [
      _FamilyMember(
        name: 'Arjun',
        relation: 'Son',
        initials: 'A',
        color: AppTheme.primary,
        online: true,
      ),
      _FamilyMember(
        name: 'Priya',
        relation: 'Daughter',
        initials: 'P',
        color: AppTheme.pink,
        online: true,
      ),
      _FamilyMember(
        name: 'Ravi',
        relation: 'Grandson',
        initials: 'R',
        color: AppTheme.green,
        online: false,
      ),
      _FamilyMember(
        name: 'Lakshmi',
        relation: 'Granddaughter',
        initials: 'L',
        color: AppTheme.purple,
        online: true,
      ),
      _FamilyMember(
        name: 'Kumar',
        relation: 'Nephew',
        initials: 'K',
        color: AppTheme.amber,
        online: false,
      ),
      _FamilyMember(
        name: 'Meena',
        relation: 'Niece',
        initials: 'M',
        color: AppTheme.teal,
        online: false,
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.pink.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.family_restroom,
                        color: AppTheme.pink, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Family',
                          style: GoogleFonts.nunito(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          'Stay connected with your loved ones',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Grid of family members
              GridView.builder(
                itemCount: family.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, i) {
                  return _FamilyCard(member: family[i]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FamilyMember {
  final String name;
  final String relation;
  final String initials;
  final Color color;
  final bool online;

  _FamilyMember({
    required this.name,
    required this.relation,
    required this.initials,
    required this.color,
    required this.online,
  });
}

class _FamilyCard extends StatelessWidget {
  final _FamilyMember member;
  const _FamilyCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          // TODO: Phase 4 — open chat / call
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar with online dot
              Stack(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: member.color.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: member.color, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        member.initials,
                        style: GoogleFonts.nunito(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: member.color,
                        ),
                      ),
                    ),
                  ),
                  if (member.online)
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppTheme.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Name
              Text(
                member.name,
                style: GoogleFonts.nunito(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),

              // Relation
              Text(
                member.relation,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 10),

              // Status
              Text(
                member.online ? 'Online' : 'Last seen recently',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                      member.online ? AppTheme.green : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}