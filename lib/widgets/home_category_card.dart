import 'package:flutter/material.dart';

class HomeCategoryCard
    extends StatelessWidget {

  final String title;
  final String subtitle;

  final IconData icon;

  final Color color;

  final VoidCallback onTap;

  const HomeCategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 16,
      ),

      child: Material(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(24),

        elevation: 3,

        child: InkWell(

          borderRadius:
              BorderRadius.circular(24),

          onTap: onTap,

          child: Padding(
            padding:
                const EdgeInsets.all(20),

            child: Row(
              children: [

                Container(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),

                  decoration: BoxDecoration(
                    color:
                        color.withOpacity(
                      0.15,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: Icon(
                    icon,
                    color: color,
                    size: 32,
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      Text(
                        title,

                        style:
                            const TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      Text(
                        subtitle,

                        style:
                            TextStyle(
                          color:
                              Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}